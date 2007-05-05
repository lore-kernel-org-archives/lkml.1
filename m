Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbXEEPZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbXEEPZl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbXEEPZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:25:30 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:16495 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbXEEPZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:25:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XylQ6aQ3p6Saqq8exewSxodxJrzXCKwJ31l9e9blBO441B3sinqgodYrhgAM6CZzaQ2GMZP0Yabie1XWbBOlrSg7P/LNYrgDkRPG/KL+umLfoee2Fwys1YQi2/DK7oxnbtSqJBdM1FJ2Qv8L22IokreDN8KK7u2/p10mR0QnZKw=
Message-ID: <a781481a0705050800r5885f146i620021026698a613@mail.gmail.com>
Date: Sat, 5 May 2007 20:30:16 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: dedekind@infradead.org
Subject: Re: [PATCH] UBI: dereference after kfree in create_vtbl
Cc: "Florin Malita" <fmalita@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-mtd@lists.infradead.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1178373562.3659.144.camel@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <463A04A5.5030103@gmail.com>
	 <a781481a0705041442h37453fb6k26d04eb5356e9dc0@mail.gmail.com>
	 <463BC019.40305@gmail.com>
	 <a781481a0705042055u5e9ba060w95da83b0fbeff76a@mail.gmail.com>
	 <1178351711.3659.54.camel@sauron>
	 <a781481a0705050526r13445d60j737a6c2015402dcc@mail.gmail.com>
	 <1178371103.3659.115.camel@sauron>
	 <a781481a0705050648l19b316acyf3d52b0545e18344@mail.gmail.com>
	 <1178373562.3659.144.camel@sauron>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/07, Artem Bityutskiy <dedekind@infradead.org> wrote:
> On Sat, 2007-05-05 at 19:18 +0530, Satyam Sharma wrote:
> > Well, you're developing / maintaining this right now, so it's your
> > call. Though I bet most people would find keeping that list_add_tail
> > local to scan.c more tasteful.
>
> I do not think so. If you are interested, try to find "UBI take 2"
> patches in lkml. Look how it looked liked. It consisted of many
> independent units and units could access other units _only_ via
> interfaces. I would do what you say there.

But what you're doing now is *worse*, don't you see it? You _think_
that you are not exporting any add_to_list function from scan.c
because you removed the wrapper from scan.h, but then you open-code it
anyway in create_vtbl (yes, that list_add _is_ the *only* meaningful
code in add_to_list; it just so _happens_ that most of its callers
till now also wanted to allocate a ubi_scan_leb too at that time so
you pushed that too into add_to_list rather than do it in the callers
-- via a separate alloc_leb, for example). Now that means there is an
*undocumented* use of the "add to list" _functionality_ outside of
scan.c anyway and which wouldn't even come up if someone tries to
analyse / overhaul the code some day in the future. I know it's just
_one_ exception, but still, I'm a heckler for style.

> Read Teo's comments - I actually now agree with them. And after I had
> changed UBI i got rid of several thousands lines of code, and the code
> became simpler.
>
> So, my argument is:
> 1. It makes no sense to introduce one more non-static function to _just_
> encapsulate list_add_tail and _just_ for one caller.

Well, introducing one more non-static function is *not* what I
originally had in mind (it was proposed only as a temporary measure
till all users of ubi_scan_add_to_list could be updated to use the
other version, explained below).

I actually planned to _replace_ ubi_scan_add_to_list with another
version that does *not* allocate memory (the __ubi_scan_add_to_list I
proposed above), and leave allocation up to its *callers* who
therefore pass a valid ubi_scan_leb to it. But that is where I ran
into ubi_scan_add_used().

> 2. It is _C_, it is _kernel_, and it is OK sometimes _not_ to follow
> computer since rules.

Ah, well, forget it. It's all a matter of taste and maintainability. I
guess in the end it needs to be fine with you.
