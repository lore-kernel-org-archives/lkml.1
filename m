Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbZFWVyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbZFWVyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbZFWVyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:54:03 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:64720 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZFWVyC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:54:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=tHCYR2TyqgGmWv1gydW29ELMKBCOILq/0bsz+JVSAkJHQo5neoJ0OgoM0f5ubx93Li
         Sx6r2JSw+S3CsDY32P2+8WVSjLJLiYl4opny0ZDhhDHCPFhF770zW4Lhp5ZJW8m9rned
         lu6WKC84Z9qVg4efBh60+Ud96y8QIdztTVKyI=
MIME-Version: 1.0
In-Reply-To: <200906232314.18261.arnd@arndb.de>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org> 
	<200906191433.34608.arnd@arndb.de> <8bd0f97a0906190612n687cdbbt1e752997acb68e49@mail.gmail.com> 
	<200906232314.18261.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 23 Jun 2009 17:53:44 -0400
Message-ID: <8bd0f97a0906231453m308dc972mdf624545794f398e@mail.gmail.com>
Subject: Re: [PATCH 05/17] Blackfin: convert to generic checksum code
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michal Simek <monstr@monstr.eu>, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 17:14, Arnd Bergmann wrote:
> --- a/lib/checksum.c
> +++ b/lib/checksum.c
> @@ -57,9 +57,9 @@ static unsigned int do_csum(const unsigned char *buff, int len)
>        odd = 1 & (unsigned long) buff;
>        if (odd) {
>  #ifdef __LITTLE_ENDIAN
> -               result = *buff;
> -#else
>                result += (*buff << 8);
> +#else
> +               result = *buff;
>  #endif
>                len--;
>                buff++;
> ---

thanks, my tests seem to work now ... i was doing telnet/rsh stuff as
well as icmp/udp/tcp flooding.  i'll convert Blackfin to generic
checksum post 2.6.31 so we can test it some more in the meantime.

>>extern unsigned short do_csum(const unsigned char *buff, int len);
>
> do_csum is really an internal function. IMHO we should better check
> csum_partial(), ip_fast_csum(), csum_fold(), csum_tcpudp_magic()
> and ip_compute_csum(), or at least a subset of them.

and this is an internal tester ... if we're going to let arches
override it, then its function signature are pretty much set in stone.
 i agree we should test every checksum function, but i think only
testing do_csum indirectly would be detrimental to the people who
would want to use this -- arch maintainers looking to implement
do_csum() themselves.  otherwise they need to step through the
surrounding functions a bit to find the exact values given to
do_csum() and the exact value expected back such that the calling
function still works.  and every arch guy is going to do this same
thing.

>>static unsigned char __initdata do_csum_data2[] = {
>>        0x0d, 0x0a,
>>};
>>static unsigned char __initdata do_csum_data3[] = {
>>        0xff, 0xfb, 0x01,
>>};
>> ...
>>static struct do_csum_data __initdata do_csum_data[] = {
>>        DO_CSUM_DATA(1, 0x0020),
>>        DO_CSUM_DATA(2, 0xfc00),
>>        DO_CSUM_DATA(3, 0x0a0d),
>>        DO_CSUM_DATA(5, 0x7fc4),
>>        DO_CSUM_DATA(7, 0x7597),
>>        DO_CSUM_DATA(255, 0x4f96),
>>};
>
> You mixed up do_csum_data2 and do_csum_data3, so they will always
> show up as incorrect.

i was going through different ways of formatting the data and looks
like i messed that up, thanks

> Also, the expected checksum is endian-dependent.
> The test module should either be modified to expect 0xffff to be
> returned in every case, or should use le16_to_cpu(0x0020) etc

i'm a bit of a nub here wrt checksuming.  the test module i came up
with by simply flooding my board and copying & pasting mismatched
buffers ;).  are you saying the following should be OK ?
-    if (tret != do_csum_data[i].ret) {
+    if (tret != le16_to_cpu(do_csum_data[i].ret)) {

unless there is a macro i could use that'd do the expansion at CPP
time so i'd write the test data as:
static struct do_csum_data __initdata do_csum_data[] = {
        DO_CSUM_DATA(1, le16_to_cpu(0x0020)),
...
-mike
