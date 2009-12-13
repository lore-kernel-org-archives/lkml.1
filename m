Return-Path: <linux-kernel-owner+w=401wt.eu-S932956AbZLMClz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956AbZLMClz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 21:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932688AbZLMCly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 21:41:54 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:61776 "HELO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932448AbZLMClx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 21:41:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=p2yesnLdXwDfiRtdbmwTMHH3o8LJ5XWoPcZ+XwpdOXwbj/zsQCAJbUqttgFe52dX+L
         EBRjH234tdfvgjUUOuiaXTx4b5uMGhoPRBEtYBgJv/JEgVDO90HghQOF/bHdlgUldGIz
         SPSE4VHGuikZoNJxjF1YyCpLbqeSeeSXasFzs=
MIME-Version: 1.0
In-Reply-To: <86802c440912121825h20663affv9ff8d004974d0d31@mail.gmail.com>
References: <86802c440912112125v4aa72189ifcc2d16ecbf79cc4@mail.gmail.com>
	 <20091211.214117.200029438.davem@davemloft.net>
	 <86802c440912121705y59eea3ebq3bdbd3e7459e748e@mail.gmail.com>
	 <86802c440912121757g474a7df4od6b50f6d5a210cf0@mail.gmail.com>
	 <86802c440912121825h20663affv9ff8d004974d0d31@mail.gmail.com>
Date: Sat, 12 Dec 2009 18:41:53 -0800
X-Google-Sender-Auth: c2e006899192c472
Message-ID: <86802c440912121841j34cde8ecv892d7d74a32313ac@mail.gmail.com>
Subject: Re: nfs broken in net-next? -- now in mainline -- bisected: 
	d9f5950f90292f7cc42834338dfd5f44dc4cc4ca
From: Yinghai Lu <yinghai@kernel.org>
To: David Miller <davem@davemloft.net>, Eric Dumazet <eric.dumazet@gmail.com>
Cc: mingo@elte.hu, sri@us.ibm.com, herbert@gondor.apana.org.au,
       torvalds@linux-foundation.org, sjayaraman@suse.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 6:25 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Sat, Dec 12, 2009 at 5:57 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Sat, Dec 12, 2009 at 5:05 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>>> [f86dcc5aa8c7908f2c287e7a211228df599e3e71] udp: dynamically
>>> size hash tables at boot time
>>
>> commit f86dcc5aa8c7908f2c287e7a211228df599e3e71
>> Author: Eric Dumazet <eric.dumazet@gmail.com>
>> Date:   Wed Oct 7 00:37:59 2009 +0000
>>
>>    udp: dynamically size hash tables at boot time
>>
>>    UDP_HTABLE_SIZE was initialy defined to 128, which is a bit small for
>>    several setups.
>>
>>    4000 active UDP sockets -> 32 sockets per chain in average. An
>>    incoming frame has to lookup all sockets to find best match, so long
>>    chains hurt latency.
>>
>>    Instead of a fixed size hash table that cant be perfect for every
>>    needs, let UDP stack choose its table size at boot time like tcp/ip
>>    route, using alloc_large_system_hash() helper
>>
>>    Add an optional boot parameter, uhash_entries=x so that an admin can
>>    force a size between 256 and 65536 if needed, like thash_entries and
>>    rhash_entries.
>>
>>    dmesg logs two new lines :
>>    [    0.647039] UDP hash table entries: 512 (order: 0, 4096 bytes)
>>    [    0.647099] UDP Lite hash table entries: 512 (order: 0, 4096 bytes)
>>
>>    Maximal size on 64bit arches would be 65536 slots, ie 1 MBytes for non
>>    debugging spinlocks.
>>
>>    Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>>    Signed-off-by: David S. Miller <davem@davemloft.net>
>>
>> cause the problem: nfs mount fail.
>>
>> the setup is:
>> 64bit kernel, have all needed drivers in kernel, and boot with
>> ip=dhcp, root disk is 256M ramdisk.
>> then try to mount nfs....
>>
>
> change entries default value from 65536 to 256,
> nfs mount will work.
>
> YH
>
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 1f95348..57c13c3 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -2054,7 +2054,7 @@ void udp4_proc_exit(void)
>  }
>  #endif /* CONFIG_PROC_FS */
>
> -static __initdata unsigned long uhash_entries;
> +static __initdata unsigned long uhash_entries = UDP_HTABLE_SIZE_MIN;
>  static int __init set_uhash_entries(char *str)
>  {
>        if (!str)
>

interesting:

m:~/dump # grep UDP dmesg.txt
[   28.996034] UDP hash table entries: 65536 (order: 11, 10485760 bytes)
[   29.032364] UDP-Lite hash table entries: 65536 (order: 11, 10485760 bytes)

will not work

but 32768 will work.
