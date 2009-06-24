Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbZFXOp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbZFXOp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZFXOpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:45:51 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:50141 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbZFXOpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:45:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nTMPhqxgaFElTmDgJG2FEzAQzlSjHZBdO087pIzLrIoVB2dYeWUtyWk4AEUHJfO4Ng
         SACmElu2rGwvFrobk8tpLOQdblhcuXDDrzRLaMzmT2ukSRO9L0gdqJWFfnkxgAeU+o1Y
         LO7C36aLVfAW+d3l56Iw+Z+K391rPkq27/sc4=
MIME-Version: 1.0
In-Reply-To: <200906241614.02615.arnd@arndb.de>
References: <1245850289-6673-1-git-send-email-vapier@gentoo.org> 
	<200906241614.02615.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 24 Jun 2009 10:45:33 -0400
Message-ID: <8bd0f97a0906240745t3a11329fg3ffc6dfb0aa3dec5@mail.gmail.com>
Subject: Re: [PATCH] add checksum selftest
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 10:14, Arnd Bergmann wrote:
> On Wednesday 24 June 2009, Mike Frysinger wrote:
>> +/*
>> + * The do_csum() interface is "internal" to the generic checksum code.
>> + * Do not require it if the arch has not switched over.
>> + */
>> +extern unsigned short do_csum(const unsigned char *buff, int len);
>
> Just nitpicking: this prototype should to into asm-generic/checksum.h,
> extern declarations have no place in .c files.

yeah, i meant to move that after the last discussion, but forgot

>> +static unsigned char __initdata do_csum_data1[] = {
>> +     0x20,
>> +};
>> +static unsigned char __initdata do_csum_data2[] = {
>> +     0x0d, 0x0a,
>> +};
>> +static unsigned char __initdata do_csum_data3[] = {
>> +     0xff, 0xfb, 0x01,
>> +};
>
> You define separate test vectors for each of the three
> cases, which looks like it could be optimized by reusing
> the same test vectors for each case.

i'm not really familiar with the interfaces to figure out how to do
this ... i just added some printks to dump arguments/buffers and then
copied & pasted ones that looked pretty different

>> +static struct csum_partial_data __initdata csum_partial_data[] = {
>> +     CSUM_PARTIAL_DATA(1,  0x00000074, 0x0),
>> +     CSUM_PARTIAL_DATA(2,  0x00000a0d, 0x0),
>> +     CSUM_PARTIAL_DATA(3,  0x0000fe00, 0x0),
>> +     CSUM_PARTIAL_DATA(5,  0x00005084, 0x0),
>> +     CSUM_PARTIAL_DATA(8,  0x1101eefe, 0x11016a80),
>> +     CSUM_PARTIAL_DATA(8b, 0x00008781, 0x847e),
>> +     CSUM_PARTIAL_DATA(9,  0x1101eefe, 0x11016b80),
>> +};
>
> For partial checksums, the result has to be folded into a 16-bit
> number using csum_fold(), because csum_partial and other functions
> return a 32-bit __wsum that can take many equivalent values taht
> are all correct.

i hear your words, but i understand them not ;)

>> +static int __init csum_tcpudp_nofold_selftest(void)
>> +{
>> +     int i, ret;
>> +     unsigned short tret, eret;
>> +
>> +     ret = 0;
>> +     for (i = 0; i < ARRAY_SIZE(csum_tcpudp_nofold_data); ++i) {
>> +             eret = le16_to_cpu(csum_tcpudp_nofold_data[i].ret);
>> +             tret = csum_tcpudp_nofold(
>> +                     csum_tcpudp_nofold_data[i].saddr,
>> +                     csum_tcpudp_nofold_data[i].daddr,
>> +                     csum_tcpudp_nofold_data[i].len,
>> +                     csum_tcpudp_nofold_data[i].proto,
>> +                     csum_tcpudp_nofold_data[i].sum);
>> +             if (tret != eret) {
>> +                     pr_err("%s: test %i: %#x != %#x: FAIL\n",
>> +                             __func__, i, tret, eret);
>> +                     ret = 1;
>> +             }
>> +     }
>> +
>> +     return ret;
>> +}
>
> same here, but you can easily use csum_tcpudp_magic() instead of
> csum_tcpudp_nofold here.

this introduces redirection that would be annoying for people who
implement just csum_tcpudp_nofold() (like the Blackfin arch).  i dont
have a problem extending the test to also cover csum_tcpudp_magic(),
but i'd like to keep the csum_tcpudp_nofold() invocation as well.
-mike
