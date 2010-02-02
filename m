Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab0BBSe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 13:34:58 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:54050 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab0BBSe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 13:34:56 -0500
Subject: Re: [PATCH] netfilter: per netns nf_conntrack_cachep
From: Jon Masters <jonathan@jonmasters.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, Eric Dumazet <eric.dumazet@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       netfilter-devel <netfilter-devel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1265134598.2861.191.camel@tonnant>
References: <1264813832.2793.446.camel@tonnant>
	 <1265023437.2848.30.camel@edumazet-laptop>
	 <1265035970.2848.50.camel@edumazet-laptop>
	 <b6fcc0a1002010658j4f52a9b8kf10e4bb07a2f1075@mail.gmail.com>
	 <1265036548.2848.55.camel@edumazet-laptop>
	 <1265108690.2861.118.camel@tonnant> <1265110504.2861.135.camel@tonnant>
	 <1265129192.2861.141.camel@tonnant> <4B685756.8010107@trash.net>
	 <1265130426.2861.158.camel@tonnant>
	 <b6fcc0a1002020958u17315624u4d54d06a413be6bb@mail.gmail.com>
	 <1265134598.2861.191.camel@tonnant>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Tue, 02 Feb 2010 13:34:36 -0500
Message-Id: <1265135676.2861.196.camel@tonnant>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 13:16 -0500, Jon Masters wrote:
> On Tue, 2010-02-02 at 19:58 +0200, Alexey Dobriyan wrote:
> 
> > Yes, moving to init_net-only function is fine.
> 
> So moving the "setup up fake conntrack" bits to init_init_net from
> init_net still results in the panic, which means that the use count
> really is dropping to zero and we really are trying to free it when
> using multiple namespaces. Per ns is probably an easier way to go.
> 
> Just for kicks, I'll have it error out on attempting to free to see if I
> can get this box to stay up for a while.

Confirmed. It boots and the hashsize is not inadvertedly corrupted if I
do the following:

void nf_conntrack_destroy(struct nf_conntrack *nfct)
{
        void (*destroy)(struct nf_conntrack *);

        if ((struct nf_conn *)nfct == &nf_conntrack_untracked) {
                printk("JCM: nf_conntrack_destroy: trying to destroy
nf_conntrack_untracked! CONTINUING...\n");
                //panic("JCM: nf_conntrack_destroy: trying to destroy
nf_conntrack_untracked!\n");
                return; /* refuse to free nf_conntrack_untracked */
        }

        rcu_read_lock();
        destroy = rcu_dereference(nf_ct_destroy);
        BUG_ON(destroy == NULL);
        destroy(nfct);
        rcu_read_unlock();
}
EXPORT_SYMBOL(nf_conntrack_destroy);

Clearly that's just a hack (though catching the specific attempt to free
the untracked conntrack sounds like a very good idea in general). I will
leave this running for a while, but so far no problems:

[jcm@perihelion jcm_26]$ dmesg|grep JCM
[   29.952717] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   30.207091] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   30.403248] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   31.403319] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   32.977106] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   33.347100] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   33.966092] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   34.967111] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   35.404323] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   35.911430] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   35.912442] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   38.967061] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   39.403342] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   41.288392] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   42.966063] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   44.036451] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   95.621174] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   95.673061] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   95.741180] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   96.273429] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   96.741296] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   97.246108] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[   98.246486] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  100.747170] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  102.252067] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  104.747066] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  105.762433] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  106.252084] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  147.260998] JCM: nf_conntrack_destroy: trying to destroy
nf_conntrack_untracked! CONTINUING...
[  155.485160] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  156.403661] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  157.402928] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  161.402477] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  163.270622] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  163.277368] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  167.718677] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  176.901877] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  182.554024] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  182.616693] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  183.616932] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  187.617026] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  188.362002] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  191.617001] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  193.574899] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  197.455338] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  214.163491] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  214.311528] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  215.311577] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  219.317496] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  220.693493] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  223.317095] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  240.326198] JCM: nf_conntrack_destroy: trying to destroy
nf_conntrack_untracked! CONTINUING...
[  252.481116] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  252.881087] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  253.881251] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  257.922816] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  258.882989] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  261.413093] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  261.921943] JCM: icmpv6_error: attaching to nf_conntrack_untracked.
[  266.350983] JCM: icmpv6_error: attaching to nf_conntrack_untracked.

So, over to you :)

Jon.


