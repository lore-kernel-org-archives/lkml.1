Return-Path: <linux-kernel-owner+w=401wt.eu-S1751638AbZFHSdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbZFHSdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbZFHSdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:33:10 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:62464 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZFHSdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:33:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ogle1V8cDa+E3sQUdP+868oV6hP8QVcZj628oiMjMP01LlmxeihG3yHbQcpL0ALngf
         r0Rp/uFvnAKo+LZvchjXrdOpiaMJD1Cdb1MRlJFDY9C4G2pHy3xhksjxmFhHPlyyxuSk
         w3WuKUDuZX0+cfTF0ka9MTwOfaXWnChX6l/44=
MIME-Version: 1.0
In-Reply-To: <1244480796.4079.301.camel@mulgrave.site>
References: <200906061959.55592.chris2553@googlemail.com>
	 <c6b1100b0906071138g2c46fb34vc1a2beb9438f1f1e@mail.gmail.com>
	 <1244413881.18742.31.camel@ht.satnam>
	 <2f9e3044bafcae848f74a1492b0ea471.squirrel@neil.brown.name>
	 <c6b1100b0906080108y191bb157n67ec681ade2a0d13@mail.gmail.com>
	 <c6b1100b0906080358y4033c402ra236eff3f972d169@mail.gmail.com>
	 <1244460875.12644.2.camel@ht.satnam>
	 <c6b1100b0906080553o2aa77a40pe0077b1b10a7d88a@mail.gmail.com>
	 <alpine.LFD.2.01.0906080916130.6847@localhost.localdomain>
	 <1244480796.4079.301.camel@mulgrave.site>
Date: Mon, 8 Jun 2009 19:33:09 +0100
Message-ID: <c6b1100b0906081133q5dc9671eu172a8a327c43cbd9@mail.gmail.com>
Subject: Re: 2.6.30-rc8 Oops whilst booting
From: Chris Clayton <chris2553@googlemail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/8 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Mon, 2009-06-08 at 09:21 -0700, Linus Torvalds wrote:
>>
>> On Mon, 8 Jun 2009, Chris Clayton wrote:
>> >
>> > OK. I reversed that change and built and installed the kernel. It has
>> > withstood 100 reboots without a panic. Additionally, I pulled the
>> > latest changes (that will be rc8-git5, I think) from kernel.org,
>> > reversed the change to that kernel and built and installed it. That
>> > too withstood 100 reboots without a panic.
>> >
>> > Let me know if there's anything else I can do to help fix this.
>>
>> That's already pretty convincing.
>>
>> James, Arjan? The original oops message is here (a jpg screen capture,
>> unable to open initial console):
>>
>>       http://lkml.org/lkml/2009/6/6/142
>>
>> and it's this bug entry:
>>
>>       Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13474
>>       Subject         : Oops whilst booting
>>       Submitter       : Chris Clayton <chris2553@googlemail.com>
>>       Date            : 2009-06-06 18:59 (2 days old)
>>       References      : http://marc.info/?l=linux-kernel&m=124431487924254&w=4
>>
>> and now bisected down to
>>
>> >> commit d5a877e8dd409d8c702986d06485c374b705d340
>> >> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
>> >> Date:   Sun May 24 13:03:43 2009 -0700
>> >>
>> >>     async: make sure independent async domains can't accidentally entangle
>>
>> please advice. Otherwise I'll have to revert.
>
> I think it's a bug in the async code.  It's providing cookies too high
> because it doesn't stop after it finds a running entry.
>
> Can we try this as the fix?
>
> James
>
> ---
>
> diff --git a/kernel/async.c b/kernel/async.c
> index 5054030..e4909ee 100644
> --- a/kernel/async.c
> +++ b/kernel/async.c
> @@ -97,7 +97,7 @@ static async_cookie_t  __lowest_in_progress(struct list_head *running)
>        if (!list_empty(running)) {
>                entry = list_first_entry(running,
>                        struct async_entry, list);
> -               ret = entry->cookie;
> +               return entry->cookie;
>        }
>
>        if (!list_empty(&async_pending)) {
>

I can also confirm that a kernel with this patch applied has withstood
the 100-boot torture. I'll try Linus's version now and report back
asap.

Chris

-- 
No, Sir; there is nothing which has yet been contrived by man, by
which so much happiness is produced as by a good tavern or inn -
Doctor Samuel Johnson
