Return-Path: <linux-kernel-owner+w=401wt.eu-S1767337AbXCIQCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767337AbXCIQCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 11:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767338AbXCIQCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 11:02:44 -0500
Received: from twin.jikos.cz ([213.151.79.26]:50005 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767337AbXCIQCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 11:02:43 -0500
Date: Fri, 9 Mar 2007 17:01:30 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
In-Reply-To: <Pine.LNX.4.64.0703091531280.26904@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0703091658350.26904@twin.jikos.cz>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> 
 <45E996A0.6070700@gmail.com> <45E99A45.9030506@gmail.com> 
 <20070303094125.838ce04d.akpm@linux-foundation.org>  <45F13791.8040408@gmail.com>
 <d120d5000703090613v2923e9c1k8389b566257daa43@mail.gmail.com>
 <Pine.LNX.4.64.0703091531280.26904@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Jiri Kosina wrote:

> If this is present also in vanilla and not only in -mm, could you please 
> try reverting commits 4237081e573b99a48991aa71364b0682c444651c and 
> d4ae650a904612ffb7edd3f28b69b022988d2466 and let me know if the 
> situation gets any better?

Hi Jiri,

or even better, does the patch below (against 2.6.21-rc3) fix the problem 
with your keyboard? I can see possibilities of report fields unaligned to 
the byte boundary, which this might be causing problems.

(the original patch author added to cc)

Thanks.

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index f4ee1af..f571513 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -873,10 +873,6 @@ static void hid_output_field(struct hid_field *field, __u8 *data)
 	unsigned size = field->report_size;
 	unsigned n;
 
-	/* make sure the unused bits in the last byte are zeros */
-	if (count > 0 && size > 0)
-		data[(offset+count*size-1)/8] = 0;
-
 	for (n = 0; n < count; n++) {
 		if (field->logical_minimum < 0)	/* signed values */
 			implement(data, offset + n * size, size, s32ton(field->value[n], size));
