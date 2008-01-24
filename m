Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbYAXNLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbYAXNLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 08:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYAXNL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 08:11:27 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:35353 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbYAXNL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 08:11:26 -0500
Date: Thu, 24 Jan 2008 18:41:26 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Krishna Kumar2 <krkumar2@in.ibm.com>,
       Denys Fedoryshchenko <denys@visp.net.lb>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc8-mm1 : net tcp_input.c warnings
Message-ID: <20080124131126.GA698@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <a8e1da0801220109v6bf8931ev50f2210402c3ba41@mail.gmail.com> <Pine.LNX.4.64.0801221115150.31652@kivilampi-30.cs.helsinki.fi> <a8e1da0801221744m37021e88h5c188e5b31ea42bf@mail.gmail.com> <20080122.190137.206066966.davem@davemloft.net> <Pine.LNX.4.64.0801230937270.31652@kivilampi-30.cs.helsinki.fi> <a8e1da0801222344l101c2b90s363821c26bc8cb55@mail.gmail.com> <Pine.LNX.4.64.0801231034300.31652@kivilampi-30.cs.helsinki.fi> <Pine.LNX.4.64.0801231256360.31652@kivilampi-30.cs.helsinki.fi> <a8e1da0801231842m128d8261oc14135716a0a2d85@mail.gmail.com> <Pine.LNX.4.64.0801241108400.31652@kivilampi-30.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0801241108400.31652@kivilampi-30.cs.helsinki.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 11:54:18AM +0200, Ilpo Järvinen wrote:
> On Thu, 24 Jan 2008, Dave Young wrote:
> 
> Hi Dave (& others),
> 
> > Thanks.
> 
> Thanks a lot, I was first to ignore all these because they occurred 
> with newreno, but looked again... :-/
> 
> > New warning trigged with your debug patch:
> 
> This was probably with the earlier one I sent to you because there's still 
> this case remaining which itself is valid:
> 
> > P: 5 L: 0 vs 0 S: 0 vs 1 w: 2044790889-2044796616 (0)
> 
> ...snip... this is still ok state (S+L <= P):
> 
> > P: 5 L: 0 vs 0 S: 0 vs 3 w: 2044790889-2044796616 (0)
> > TCP wq(s)      <
> > TCP wq(h) +++h+<
> > l0 s3 f0 p5 seq: su2044790889 hs2044795029 sn2044796616
> > ------------[ cut here ]------------
> > WARNING: at net/ipv4/tcp_input.c:2169 tcp_mark_head_lost+0x122/0x150()
> > Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event
> > snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss eeprom e100 psmouse
> > snd_hda_intel snd_pcm snd_timer btusb bluetooth serio_raw snd 3c59x sg
> > evdev thermal soundcore rtc_cmos snd_page_alloc rtc_core rtc_lib
> > i2c_i801 processor button intel_agp dcdbas pcspkr agpgart
> > Pid: 0, comm: swapper Not tainted 2.6.24-rc8-mm1 #8
> >  [<c0132100>] ? have_callable_console+0x20/0x30
> >  [<c0131844>] warn_on_slowpath+0x54/0x80
> >  [<c03ffe54>] ? tcp_print_queue+0x1a4/0x230
> >  [<c0132438>] ? vprintk+0x308/0x320
.
.
<snip>
.
.

> > ---[ end trace 14b601818e6903ac ]---
> 
> ...But this no longer is, and even more, L: 5 is not valid state at this 
> point all (should only happen if we went to RTO but it would reset S to 
> zero with newreno):
> 
> > P: 5 L: 5 vs 5 S: 0 vs 3 w: 2044790889-2044796616 (0)
> > TCP wq(s) LLLLl<
> > TCP wq(h) +++h+<
> > l5 s3 f0 p5 seq: su2044790889 hs2044795029 sn2044796616
> 
> Surprisingly, it was the first time the WARN_ON for left_out returned 
> correct location. This also explains why the patch I sent to Krishna 
> didn't print anything (it didn't end up into printing because I forgot 
> to add L+S>P check into to the state checking if).
> 
> ...so please, could you (others than Denys) try this patch, it should 
> solve the issue. And Denys, could you confirm (and if necessary double 
> check) that the kernel you saw this similar problem with is the pure 
> Linus' mainline, i.e., without any net-2.6.25 or mm bits please, if so, 
> that problem persists. And anyway, there were some fackets_out related 
> problems reported as well and this doesn't help for that but I think I've 
> lost track of who was seeing it due to large number of reports :-), could 
> somebody refresh my memory because I currently don't have time to dig it 
> up from archives (at least on this week).
> 
> 
> -- 
>  i.
> 
> --
> [PATCH] [TCP]: NewReno must count every skb while marking losses
> 
> NewReno should add cnt per skb (as with FACK) instead of depending
> on SACKED_ACKED bits which won't be set with it at all.
> Effectively, NewReno should always exists after the first
> iteration anyway (or immediately if there's already head in
> lost_out.
> 
> This was fixed earlier in net-2.6.25 but got reverted among other
> stuff and I didn't notice that this is still necessary (actually
> wasn't even considering this case while trying to figure out the
> reports because I lived with different kind of code than it in
> reality was).
> 
> This should solve the WARN_ONs in TCP code that as a result of
> this triggered multiple times in every place we check for this
> invariant.
> 
> Special thanks to Dave Young <hidave.darkstar@gmail.com> and
> Krishna Kumar2 <krkumar2@in.ibm.com> for trying with my debug
> patches.

Hi,

Thanks, after applying the patch the warning is not seen.


  Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> ---
>  net/ipv4/tcp_input.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 295490e..aa409a5 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -2156,7 +2156,7 @@ static void tcp_mark_head_lost(struct sock *sk, int packets, int fast_rexmit)
>  		tp->lost_skb_hint = skb;
>  		tp->lost_cnt_hint = cnt;
> 
> -		if (tcp_is_fack(tp) ||
> +		if (tcp_is_fack(tp) || tcp_is_reno(tp) ||
>  		    (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED))
>  			cnt += tcp_skb_pcount(skb);
> 
> -- 
> 1.5.2.2


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
