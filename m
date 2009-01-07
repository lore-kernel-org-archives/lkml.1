Return-Path: <linux-kernel-owner+w=401wt.eu-S1763333AbZAGXIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763333AbZAGXIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZAGXIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:08:14 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:19939 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbZAGXIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:08:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=jPPsmlzzwCLOI7fWlO0Pyk0ntqaqBorTORr+U5bCvHoLP2i9A1/K6ME0oy9+8vn0P9
         chiVtaOBsunq68K6Wg8A5Qq7Cd37+YHe1GSZVLDzUyvMEN6+Nx2ZeM41vNfDcaSUZtDw
         0AHMhHgTjwknymvuDHezQuPRgiza7A3dYygxE=
Message-ID: <496535D9.6040606@gmail.com>
Date: Thu, 08 Jan 2009 00:08:09 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>
Subject: broken daemonize (COW credentials?)
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm observing daemonize crashes with this code:
static struct pid *pid;
static DECLARE_COMPLETION(comp);

static int bubak(void *data)
{
        daemonize("bubak");
        while (!signal_pending(current))
                msleep_interruptible(5000);
        complete_and_exit(&comp, 0);
        return 0;
}

static int init1(void) <-- module_init function
{
        int ret;

        ret = kernel_thread(bubak, NULL, 0);
        if (ret < 0)
                return ret;
        pid = find_get_pid(ret);
	return 0;
}
----------------------- cut here -------------------

This is due to:
daemonize
 -> exit_mm
   -> tsk->mm = NULL; (i.e. current->mm)
 -> reparent_to_kthreadd
   -> commit_creds
     -> set_dumpable(task->mm, suid_dumpable); (i.e. current->mm)

The culprit is probably COW credentials. David?
