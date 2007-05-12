Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbXELDSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbXELDSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 23:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbXELDSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 23:18:35 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:19181 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323AbXELDSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 23:18:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PcOfNR8IuQyMZ1X/VpTW4YLBkPY1kg8+uEzEJNnyoJT0tfDyfwPCM9QFFuD8s8d6JwCFHBqHNyKLBQuB2KExaF6NqCgk3akfTjTGNnH6eUkKMB2i8TB1iKhj9kYAx+KBn1NkdKzSHJhfHPAhRNrftTbCHGbBjqHxRdT4nKy7ppQ=
Subject: Is this a preempt issue in drivers/input/evdev.c
From: "Yin,Fengwei" <yfw.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Sat, 12 May 2007 11:18:45 +0800
Message-Id: <1178939925.14713.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
When open/close evdev, the code is as following to handle multi-client
operation:
static int evdev_release(...)
{
	...
	if (!--evdev->open) {
		<------------preempted
		if (evdev->exist)
			input_close_device(...);
		else
			evdev_free(evdev);
	}
	return 0;
}

static int evdev_open(...)
{
	...
	if (!evdev->open++ && evdev->exist)｛
		errror = input_open_device(...);
		if (error) {
			...
		}
	}
	...
	return 0;
}

So if the evdev_release() is preempted at the point marked by another
process which will open the evdev, which will make operation sequence
like:

   --evdev->open in evdev_release()
         -----> preempted
	                            evdev->open++ and input_open_devie()
	 <----- reschedule 
	input_close_device()

Should we introduce a mutex here? Or do I miss something? Thanks.

Regards
Yin, Fengwei


	



