Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0BANuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 08:50:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:38481 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab0BANuJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 08:50:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kPCwJeasdri7Qhr8co7tIktWBKngb/qZKYjSH6r+TajqCE7zCSTzaymle73eYyWlAQ
         QvWrTK93lPYhgyXwKh/4QwvK4Lv24xCyBBsBW+mEaK6kMX9TC649idUmwpQca3asAuSw
         7d/SePogPANyk6Gq2gqb/4LJ8SiLMkMlemZU4=
MIME-Version: 1.0
In-Reply-To: <20100130125327.GA4258@x200>
References: <20100129094822.GA8294@nb-core2.darkstar.lan>
	 <b6fcc0a1001290217l4edb0a0btbafa0c26b6f14ad5@mail.gmail.com>
	 <1264778549.3184.28.camel@edumazet-laptop>
	 <1264782806.3184.42.camel@edumazet-laptop>
	 <20100130125327.GA4258@x200>
Date: Mon, 1 Feb 2010 14:50:02 +0100
Message-ID: <68676e01002010550l2654208dged864973a996c381@mail.gmail.com>
Subject: Re: [PATCH] af_key: fix netns ops ordering on module load/unload
From: Luca Tettamanti <kronos.it@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 1:53 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Fri, Jan 29, 2010 at 05:33:26PM +0100, Eric Dumazet wrote:
>> @@ -3807,21 +3807,24 @@ static int __init ipsec_pfkey_init(void)
>>       if (err != 0)
>>               goto out;
>>
>> -     err = sock_register(&pfkey_family_ops);
>> -     if (err != 0)
>> -             goto out_unregister_key_proto;
>>       err = xfrm_register_km(&pfkeyv2_mgr);
>>       if (err != 0)
>> -             goto out_sock_unregister;
>> +             goto out_unregister_key_proto;
>> +
>>       err = register_pernet_subsys(&pfkey_net_ops);
>>       if (err != 0)
>>               goto out_xfrm_unregister_km;
>> +
>> +     err = sock_register(&pfkey_family_ops);
>> +     if (err != 0)
>> +             goto out_unregister_pernet;
>>  out:
>>       return err;
>> +
>> +out_unregister_pernet:
>> +     unregister_pernet_subsys(&pfkey_net_ops);
>>  out_xfrm_unregister_km:
>>       xfrm_unregister_km(&pfkeyv2_mgr);
>> -out_sock_unregister:
>> -     sock_unregister(PF_KEY);
>>  out_unregister_key_proto:
>>       proto_unregister(&key_proto);
>>       goto out;
>
> ACK analysis, except this is not enough.
>
> Here is patch which survived netns start/stop/modprobe/rmmod cycles.
>
>        Alexey, who still doesn't get why bug reproduces so easily for bug reporter.
>
> Luca, please confirm.

Seems to work fine.

> [PATCH] af_key: fix netns ops ordering on module load/unload
>
> 1. After sock_register() returns, it's possible to create sockets,
>   even if module still not initialized fully (blame generic module code
>   for that!)
> 2. Consequently, pfkey_create() can be called with pfkey_net_id still not
>   initialized which will BUG_ON in net_generic():
>        kernel BUG at include/net/netns/generic.h:43!
> 3. During netns shutdown, netns ops should be unregistered after
>   key manager unregistered because key manager calls can be triggered
>   from xfrm_user module:
>
>        general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>        pfkey_broadcast+0x111/0x210 [af_key]
>        pfkey_send_notify+0x16a/0x300 [af_key]
>        km_state_notify+0x41/0x70
>        xfrm_flush_sa+0x75/0x90 [xfrm_user]
> 4. Unregister netns ops after socket ops just in case and for symmetry.
>
> Reported by Luca Tettamanti.
>
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Tested-by: Luca Tettamanti <kronos.it@gmail.com>

thanks,
Luca
