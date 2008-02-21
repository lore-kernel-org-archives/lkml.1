Return-Path: <linux-kernel-owner+w=401wt.eu-S933698AbYBUQdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698AbYBUQdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758764AbYBUQc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:32:58 -0500
Received: from mail.vyatta.com ([216.93.170.194]:33364 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757450AbYBUQc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:32:56 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.334
Date: Thu, 21 Feb 2008 08:32:48 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Tilman Schmidt <tilman@imap.cc>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org
Subject: Re: 2.6.25-rc2-mm1 - several bugs and a crash
Message-ID: <20080221083248.5b76b496@extreme>
In-Reply-To: <47BD6072.4000407@trash.net>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<47BC982C.7050402@imap.cc>
	<47BD6072.4000407@trash.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 12:28:50 +0100
Patrick McHardy <kaber@trash.net> wrote:

> Tilman Schmidt wrote:
> > Still, X came up fine, I could log in (Gnome feeling subjectively
> > a bit sluggish), call up a web page from the Internet in Firefox,
> > and start perusing the logs, when the whole system froze: neither
> > mouse nor keyboard would react anymore, and only the Wind^Wreset
> > button would put me back in control. After rebooting into the
> > previous, non-mm kernel I found this in the syslog:
> > 
> > Feb 20 17:22:40 xenon kernel: [   48.180297] BUG: using smp_processor_id() in preemptible [00000000] code: ntpdate/3562
> > Feb 20 17:22:40 xenon kernel: [   48.180297] caller is __nf_conntrack_find+0x9b/0xeb [nf_conntrack]
> > Feb 20 17:22:40 xenon kernel: [   48.180297] Pid: 3562, comm: ntpdate Not tainted 2.6.25-rc2-mm1-testing #1
> > Feb 20 17:22:40 xenon kernel: [   48.180297]  [<c02015b9>] debug_smp_processor_id+0x99/0xb0
> 
> 
> Could you test whether this patch fixes the netfilter
> warnings please?
> 

> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 327e847..b77eb56 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -256,13 +256,19 @@ __nf_conntrack_find(const struct nf_conntrack_tuple *tuple)
>  	struct hlist_node *n;
>  	unsigned int hash = hash_conntrack(tuple);
>  
> +	/* Disable BHs the entire time since we normally need to disable them
> +	 * at least once for the stats anyway.
> +	 */
> +	local_bh_disable();

Use rcu_read_lock instead. local_bh_disable() won't work with some of the other forms
of RCU alternatives.

