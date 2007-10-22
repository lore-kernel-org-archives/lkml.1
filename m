Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbXJVDrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbXJVDrG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 23:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbXJVDqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 23:46:55 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:9709 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbXJVDqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 23:46:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=fJj1FKE1ajVLEZQmiAXZOxcyGRxXuAQr8GwLcYYZZI4dxxx4Z5y1EFH/ssRhF4Md80KUpN+8H+CQNLC4c5V/r28mWe7obEHbfJz3Fthi+c7CEne4r5X0iWopEW8QSUoHUCoxYuVo1GBAB2J0Zm30rmuqlzwUzGY4sLk5v89MILQ=
Message-ID: <471C1D29.5020403@gmail.com>
Date: Sun, 21 Oct 2007 23:46:49 -0400
From: emist <emistz@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Linux <linux-kernel@vger.kernel.org>
CC: geraldsc@de.ibm.com, cotte@de.ibm.com, linux390@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: Re: [PATCH] Bug fix for the s390 dcssblk driver
References: <200710201451.57138.elendil@planet.nl> <471A39D2.1070303@gmail.com> <20071021100926.GA4420@osiris.ibm.com>
In-Reply-To: <20071021100926.GA4420@osiris.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------010307020508060901070905"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010307020508060901070905
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Heiko Carstens wrote:
> On Sat, Oct 20, 2007 at 01:24:34PM -0400, emist wrote:
>> Frans Pop wrote:
>>> emist wrote:
>>>> The following patch fixes and issue in the s390 dcssblk driver. The
>>>> issue is caused when an unsuccessful attempt is made in order to change
>>>> a segment's type through the device attribute file "shared". This causes
>>>> the driver to remove the device in question, removing with it the device
>>>> attribute which is currently handling the call. The result is a hang on
>>>> the driver as it removes memory from under its feet.
>>>>
>>>> Not exactly sure if this explanation makes sense or its entirely
>>>> accurate. This is what I believe at this point from encountering and
>>>> fixing the error. Anyway here is the patch, hope it helps.
>>> Hi,
>>>
>>> If you don't get any reactions to your patch during the next few days, I 
>>> suggest you resend it and then CC the linux-s390@vger.kernel.org list and 
>>> possibly also the maintainer at linux390@de.ibm.com.
>>>
>>> In general you should always try to CC the relevant list/people as listed in 
>>> the MAINTAINERS file and not just the linux-kernel list, both for patches 
>>> and when reporting problems.
>>>
>>> Cheers,
>>> Frans Pop
>>>
>> Thanks Frans, I will do as you suggest.
>>
>> Have a good one,
>>
>> Igor H.
> 
> Gerald or Carsten (cc'ed) should look into this.
> Thanks for reporting.
> 

Hello,

I realized that I did not fix one of the cases where this bug manifests
in my last patch. Here is the complete patch to fix the issue. And this
time I cc'ed the relevant people.

Have a good one,

Igor H.



--------------010307020508060901070905
Content-Type: text/plain;
 name="dcssblk_fix"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dcssblk_fix"

# This patch fixes a memory corruption bug in the s390 dcssblk driver.
# The bug occurs when an attempt to change the type of a segment
# returns an error. At this point the driver tries to remove the segment in
# question while some of the device's attributes are in use. This causes the
# driver to hang.
#
# questions/comments @ emistz@gmail.com


diff -urN linux-2.6.23.1/drivers/s390/block/dcssblk.c linuxx/drivers/s390/block/dcssblk.c
--- linux-2.6.23.1/drivers/s390/block/dcssblk.c	2007-10-20 01:19:29.000000000 -0400
+++ linuxx/drivers/s390/block/dcssblk.c	2007-10-20 01:16:13.000000000 -0400
@@ -230,8 +230,15 @@
 					   SEGMENT_SHARED);
 		if (rc < 0) {
 			BUG_ON(rc == -EINVAL);
-			if (rc != -EAGAIN)
-				goto removeseg;
+			if (rc != -EAGAIN){
+						PRINT_DEBUG
+				    ("Could not reload segment %s in the specified format, reloading\n",
+				     dev_info->segment_name);
+				rc = segment_modify_shared(dev_info->
+							   segment_name,
+							   SEGMENT_EXCLUSIVE);
+				goto out;
+			}
 		} else {
 			dev_info->is_shared = 1;
 			switch (dev_info->segment_type) {
@@ -253,8 +260,12 @@
 					   SEGMENT_EXCLUSIVE);
 		if (rc < 0) {
 			BUG_ON(rc == -EINVAL);
-			if (rc != -EAGAIN)
-				goto removeseg;
+			if (rc != -EAGAIN){
+				PRINT_DEBUG("Could not reload segment %s in the specified format, reloading\n",
+					dev_info->segment_name);
+				rc = segment_modify_shared(dev_info->segment_name, SEGMENT_SHARED);
+				goto out;	
+			}
 		} else {
 			dev_info->is_shared = 0;
 			set_disk_ro(dev_info->gd, 0);

--------------010307020508060901070905--
