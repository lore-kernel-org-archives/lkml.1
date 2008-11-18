Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbYKRJMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbYKRJMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 04:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbYKRJMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 04:12:17 -0500
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:44841 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750888AbYKRJMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 04:12:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gtTsePxlf+SFMXWcCSFVjEN3GQYIxYX0J32WOiG3RlSmfVEJd/yP3i/YfLjg7Tk3SZ03LiOtLnYfCLoJWSWRZfjmuTYG3tRoJjTGFb6mJIFV/SHC0j3GqezWlkaLdqETjUT3kv+pPM1H6qAw08WiJoiOEa6MT1w1iWkGXP0KtWo=  ;
X-YMail-OSG: 5xmnAGgVM1lBKAsFTz3LympAy6FYVm1HlGlfwjLL1xJqtPMbQxKU6fdc7vXZ9nFXpKA3s.c3fYXOaP7GcQDzAmPFTtEbNnhg.FXLXQbbKrXpYJanxreTcckewsUsqgM6nFWCQnerY_a.lhYbnVlEBhGwmjzVRqUp7EeXmrkTq8P6SpGG.S7312Q0hle8
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: ip_queue_xmit(): Re: [Bug #11308] tbench regression on each kernel release from 2.6.22 -&gt; 2.6.28
Date: Tue, 18 Nov 2008 20:12:02 +1100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, Stephen Hemminger <shemminger@vyatta.com>
References: <20081117110119.GL28786@elte.hu> <20081117184951.GA5585@elte.hu> <20081117203219.GC12020@elte.hu>
In-Reply-To: <20081117203219.GC12020@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811182012.03386.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 November 2008 07:32, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> > 100.000000 total
> > ................
> >   3.356152 ip_queue_xmit

> 30% of the overhead of this function comes from:
>
> ffffffff804b7203:        0 	66 c7 43 06 00 00    	movw   $0x0,0x6(%rbx)
> ffffffff804b7209:      118 	0f bf 85 40 02 00 00 	movswl 0x240(%rbp),%eax
> ffffffff804b7210:    10867 	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
> ffffffff804b7215:      340 	85 c0                	test   %eax,%eax
> ffffffff804b7217:        0 	79 06                	jns    ffffffff804b721f
> <ip_queue_xmit+0x1da> ffffffff804b7219:   107464 	8b 82 9c 00 00 00    	mov
>    0x9c(%rdx),%eax ffffffff804b721f:     4963 	88 43 08             	mov   
> %al,0x8(%rbx)
>
> the 16-bit movw looks a bit weird. It comes from line 372:
>
>  0xffffffff804b7203 is in ip_queue_xmit (net/ipv4/ip_output.c:372).
>  367		iph = ip_hdr(skb);
>  368		*((__be16 *)iph) = htons((4 << 12) | (5 << 8) | (inet->tos & 0xff));
>  369		if (ip_dont_fragment(sk, &rt->u.dst) && !ipfragok)
>  370			iph->frag_off = htons(IP_DF);
>  371		else
>  372			iph->frag_off = 0;
>  373		iph->ttl      = ip_select_ttl(inet, &rt->u.dst);
>  374		iph->protocol = sk->sk_protocol;
>  375		iph->saddr    = rt->rt_src;
>  376		iph->daddr    = rt->rt_dst;
>
> the ip-header fragment flag setting to zero.
>
> 16-bit ops are an on-off love/hate affair on x86 CPUs. The trend is
> towards eliminating them as much as possible.
>
> _But_, the real overhead probably comes from:
>
>  ffffffff804b7210:    10867 	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
>
> which is the next line, the ttl field:
>
>  373             iph->ttl      = ip_select_ttl(inet, &rt->u.dst);
>
> this shows that we are doing a hard cachemiss on the net-localhost
> route dst structure cacheline. We do a plain load instruction from it
> here and get a hefty cachemiss. (because 16 CPUs are banging on that
> single route)

Why would that show up right there, though? Instruction like this should
be non-blocking. Shouldn't the cost should show up at some point where the
CPU executes an instruction depending on rdx? (and good luck working out
when that happens!)

