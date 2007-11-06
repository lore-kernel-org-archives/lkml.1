Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbXKFJHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbXKFJHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 04:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbXKFJGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 04:06:53 -0500
Received: from nz-out-0506.google.com ([64.233.162.224]:48149 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964AbXKFJGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 04:06:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=RI8AeGdu17hF4a9WTuGZtvmh2++kslUeLDUaiAIaFg4zVj8eXZ7kAmKXRhhib0WqRCWAg9bnfOxH12bzZ2BPpQCK2rHvlBWy2Seut0RiCVCeu9KR8+01D4ihmVoSwrcOyJgBFPHJKH+bN5GNg/qlNpgaRsNiNn48zqhtkeum7Mc=
Message-ID: <47302E9F.6020708@gmail.com>
Date: Tue, 06 Nov 2007 18:06:39 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Peter Osterlund <petero2@telia.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Maier <balagi@justmail.de>, gregkh@suse.de
Subject: Re: pktcdvd oops
References: <20071105092018.GD5359@kernel.dk> <Pine.LNX.4.64.0711052312410.5445@quad.localdomain>
In-Reply-To: <Pine.LNX.4.64.0711052312410.5445@quad.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/mixed;
 boundary="------------050606050004020807000100"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050606050004020807000100
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

[Greg cc'd]

Peter Osterlund wrote:
> On Mon, 5 Nov 2007, Jens Axboe wrote:
> 
>> Hi Peter,
>>
>> You don't seem to have a bugzilla account, so could not reassign to you.
>> See http://bugzilla.kernel.org/show_bug.cgi?id=9294
> 
> Problem is repeatable on my computer. It dies in __module_get() on this
> line:
> 
>         BUG_ON(module_refcount(module) == 0);
> 
> I think this is because commit 7b595756ec1f49e0049a9e01a1298d53a7faaa15,
> which states: "Note that with this change, userland holding a sysfs node
> does not prevent the backing module from being unloaded."
> 
> Unfortunately, I don't know how this sysfs stuff is supposed to work,
> and therefore don't know how to fix the problem.

Does this fix the problem?

-- 
tejun

--------------050606050004020807000100
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index a8130a4..a5ee213 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -358,10 +358,19 @@ static ssize_t class_pktcdvd_store_add(struct class *c, const char *buf,
 					size_t count)
 {
 	unsigned int major, minor;
+
 	if (sscanf(buf, "%u:%u", &major, &minor) == 2) {
+		/* pkt_setup_dev() expects caller to hold reference to self */
+		if (!try_module_get(THIS_MODULE))
+			return -ENODEV;
+
 		pkt_setup_dev(MKDEV(major, minor), NULL);
+
+		module_put(THIS_MODULE);
+
 		return count;
 	}
+
 	return -EINVAL;
 }
 

--------------050606050004020807000100--
