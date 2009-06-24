Return-Path: <linux-kernel-owner+w=401wt.eu-S1761959AbZFXTnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959AbZFXTnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761903AbZFXTnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:43:32 -0400
Received: from mail-yx0-f173.google.com ([209.85.210.173]:41839 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761799AbZFXTna convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:43:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xXX5rMKOLUAPUj4EdDbHgfHeH3vO7O5Wu1TcOUh4wdRbkhTA2wNWGbPjF/snzUkElQ
         00sDCVLqUyn5JVCZjaf50/CCubxXb55e69DYCdEEEQSOotmx4Wq6agTsAkJS3hIPf+gC
         6gN4CdUPk2aGXwXBpJke9Mj1F9c/jMlt0akCQ=
MIME-Version: 1.0
In-Reply-To: <200906241724.30947.arnd@arndb.de>
References: <1245850289-6673-1-git-send-email-vapier@gentoo.org> 
	<200906241614.02615.arnd@arndb.de> <8bd0f97a0906240745t3a11329fg3ffc6dfb0aa3dec5@mail.gmail.com> 
	<200906241724.30947.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 24 Jun 2009 15:43:13 -0400
Message-ID: <8bd0f97a0906241243k1d4a6d25x3216e940b356d2ca@mail.gmail.com>
Subject: Re: [PATCH] add checksum selftest
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 11:24, Arnd Bergmann wrote:
> On Wednesday 24 June 2009, Mike Frysinger wrote:
>> >> +static unsigned char __initdata do_csum_data1[] = {
>> >> +     0x20,
>> >> +};
>> >> +static unsigned char __initdata do_csum_data2[] = {
>> >> +     0x0d, 0x0a,
>> >> +};
>> >> +static unsigned char __initdata do_csum_data3[] = {
>> >> +     0xff, 0xfb, 0x01,
>> >> +};
>> >
>> > You define separate test vectors for each of the three
>> > cases, which looks like it could be optimized by reusing
>> > the same test vectors for each case.
>>
>> i'm not really familiar with the interfaces to figure out how to do
>> this ... i just added some printks to dump arguments/buffers and then
>> copied & pasted ones that looked pretty different
>
> I just mean you can consolidate

ok, i'll take a stab at that

>> >> +static struct csum_partial_data __initdata csum_partial_data[] = {
>> >> +     CSUM_PARTIAL_DATA(1,  0x00000074, 0x0),
>> >> +     CSUM_PARTIAL_DATA(2,  0x00000a0d, 0x0),
>> >> +     CSUM_PARTIAL_DATA(3,  0x0000fe00, 0x0),
>> >> +     CSUM_PARTIAL_DATA(5,  0x00005084, 0x0),
>> >> +     CSUM_PARTIAL_DATA(8,  0x1101eefe, 0x11016a80),
>> >> +     CSUM_PARTIAL_DATA(8b, 0x00008781, 0x847e),
>> >> +     CSUM_PARTIAL_DATA(9,  0x1101eefe, 0x11016b80),
>> >> +};
>> >
>> > For partial checksums, the result has to be folded into a 16-bit
>> > number using csum_fold(), because csum_partial and other functions
>> > return a 32-bit __wsum that can take many equivalent values taht
>> > are all correct.
>>
>> i hear your words, but i understand them not ;)
>
> The problem is that IP checksumming is only defined for 16-bit
> words. We use __wsum (32 bits) as an intermediate in the networking
> stack so we can consolidate the folding in one place. If you have
> a test vector that results in checksum 0xffff (as a well-formed
> packet should), the __wsum could be one of 0x0000ffff, 0xffff0000,
> 0xffffffff, 0x1234edcb, for any other value x where
> (((x >> 16) + (x & 0xffff)) >> 16 + ((x >> 16) + (x & 0xffff)))
> & 0xffff = 0xffff. The specific __wsum returned by csum_partial()
> is implementation specific, so you cannot compare it to a
> precomputed value unless sending it through csum_fold().

ok, i can see that for the result, but how do i handle the functions
that also take a __wsum ?  do i just always pass them 0 to avoid
implementation issues ?
-mike
