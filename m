Return-Path: <linux-kernel-owner+w=401wt.eu-S934252AbYBGUMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252AbYBGUMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933309AbYBGUI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:08:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:48104 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933298AbYBGUIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:08:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=nSSLLxeUKO9yG/7zCLKA1Y5Nkkf5H8WTxj4rGYFxiWli0hCTVpGvIUyumvAIQWnCZzWZI0VLyCPy6hD2iH9o+svAiBHlBq/xzBNfdKbK5eP0VzbyqEgs7QCrgXFayhAX3Ofcvf7sU+HdbijpxnSj5yIO6EBQ4Qb37Wcq+k/Mzd8=
Message-ID: <47AB6552.7040503@gmail.com>
Date: Thu, 07 Feb 2008 21:08:50 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       Grant Likely <grant.likely@secretlab.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Xilinx: hwicap driver comments
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

first of all, I think that the driver should go through lkml before upstream 
merge or at least be in -mm for a while (I think this used to be a rule some 
time ago), correct me if I'm wrong, but none of it happened.

Few comments I have:
- release f_op retval is silently ignored, I guess you will get your device into 
undefined state when the first function fails (esp. when you interrupt the sem)
- semaphores are deprecated
- class_device_create is deprecated
- module_init/exit functions should be __init, not __devinit/exit (not a bug, 
it's subset)
- this piece:
         drvdata = kmalloc(sizeof(struct hwicap_drvdata), GFP_KERNEL);
         if (!drvdata) {
                 dev_err(dev, "Couldn't allocate device private record\n");
                 return -ENOMEM;
         }
  memset((void *)drvdata, 0, sizeof(struct hwicap_drvdata));

  kmalloc + memset = kzalloc
  null probed_devices[id] on that fail path and on failed1 label

- from/to (void *) casts are useless
- io resources are at least ulong
- don't understand this:
                 memcpy(kbuf, drvdata->read_buffer, bytes_remaining);
                 drvdata->read_buffer_in_use = bytes_remaining;
                 free_page((unsigned long)kbuf);
- can this overlap (=>memmove)?
                 memcpy(drvdata->read_buffer + bytes_to_read,
                                 drvdata->read_buffer, 4 - bytes_to_read);
- is platform probing function race-proof (like pci)?
- run sparse on it, you mix __user with non-__user at least
