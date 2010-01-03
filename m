Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299Ab0ACTNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab0ACTNw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 14:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716Ab0ACTNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 14:13:52 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:40387 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0ACTNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 14:13:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Fiqp6t2RI7HK5jUFze4S60Y/kZVZR2ve4MjECn058t2dL5Zb9liGGBoXWaJkQfm17W
         NxDb7l7p7+e1dtWjQJ/cGEhSV94Ez+z/4XMtyKiRthtYO9fwp18J3fSoRdTY0V/IW15/
         mywEG2pwZjZs7mbSqBcEiJ5e80z0QD0pV9E/U=
Subject: [block subsystem] Need help to prevent races on unexpected device
 removal
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 03 Jan 2010 21:13:47 +0200
Message-ID: <1262546027.4555.17.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During development of hotplug support for mtd translation layer I seems
to be unable to figure a way to prevent following race:

First of all, a block device is registered. I attach a private structure
to that device to save all internal information.

Then out of the blue (when user pulls off the card) I receive a request
to remove the device.

In the function that handles such removal, I do:

del_gendisk(...
blk_start_queue

stop thread that processes the requests

blk_cleanup_queue(old->rq);


The problem is that I don't know where/when to free the private
structure.

I though about adding a field to the structure, with name 'invalid', so
that release will not attempt to go futher, but free the structure, but
what happens if release is never called?
In other words this will work as long as there is a user of the block
device.

I thought then that I can detect that condition and free the structure
in the removal function itself, but then I get a race with ->open
running in same time, and mutex will not prevent it, I will have to
release it somwhen, and then ->open will access a freed structure....


Best regards,
Maxim Levitsky

