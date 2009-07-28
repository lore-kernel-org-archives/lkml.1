Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbZG1OzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbZG1OzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 10:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZG1OzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 10:55:10 -0400
Received: from smtp-out.google.com ([216.239.45.13]:1700 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbZG1OzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 10:55:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=XVicGcC7o36WtnKVLlZavY9B3/pSq2Uvpfy0CCig+n/am9ILkAgzjfgh3dGrRxIi5
	FJMG94TdqdvIMX32E4w+A==
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.0907272017280.20984@fbirervta.pbzchgretzou.qr>
References: <20090727134457.12897.272.stgit@jazzy.zrh.corp.google.com>
	 <20090727134621.12897.75558.stgit@jazzy.zrh.corp.google.com>
	 <alpine.LSU.2.00.0907272017280.20984@fbirervta.pbzchgretzou.qr>
Date: Tue, 28 Jul 2009 16:55:01 +0200
Message-ID: <b5ddba180907280755k725440fag79d39f18ebc7d28d@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/5] netfilter: xt_ipvs (netfilter matcher for ipvs)
From: Hannes Eder <heder@google.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 20:35, Jan Engelhardt<jengelh@medozas.de> wrote:
>
> On Monday 2009-07-27 15:46, Hannes Eder wrote:
>>--- /dev/null
>>+++ b/include/linux/netfilter/xt_ipvs.h
>>@@ -0,0 +1,32 @@
>>+#ifndef _XT_IPVS_H
>>+#define _XT_IPVS_H 1
>>+
>>+#ifndef _IP_VS_H
>
> Do the definitions (should probably be enums) exist in
> very old <linux/ip_vs.h>? Then maybe you can get rid of them
> from xt_ipvs.h.

Definitions removed from xt_ipvs.h.  For xt_ipvs.c I just included
linux/ip_vs.h.  For libxt_ipvs (user space library) I added the entire
linux/ip_vs.h.  Do you think this is better?

>>+#define IP_VS_CONN_F_FWD_MASK 0x0007          /* mask for the fwd methods */
>>+#define IP_VS_CONN_F_MASQ     0x0000          /* masquerading/NAT */
>>+#define IP_VS_CONN_F_LOCALNODE        0x0001          /* local node */
>>+#define IP_VS_CONN_F_TUNNEL   0x0002          /* tunneling */
>>+#define IP_VS_CONN_F_DROUTE   0x0003          /* direct routing */
>>+#define IP_VS_CONN_F_BYPASS   0x0004          /* cache bypass */
>>+#endif
>>+
>>+#define XT_IPVS_IPVS          0x01 /* this is implied by all other options */
>>+#define XT_IPVS_PROTO         0x02
>>+#define XT_IPVS_VADDR         0x04
>>+#define XT_IPVS_VPORT         0x08
>>+#define XT_IPVS_DIR           0x10
>>+#define XT_IPVS_METHOD                0x20
>>+#define XT_IPVS_MASK          (0x40 - 1)
>>+#define XT_IPVS_ONCE_MASK     (XT_IPVS_MASK & ~XT_IPVS_IPVS)
>>+
>>+struct xt_ipvs {
>>+      union nf_inet_addr      vaddr, vmask;
>>+      __be16                  vport;
>>+      u_int16_t               l4proto;
>>+      u_int16_t               fwd_method;
>>+
>>+      u_int8_t invert;
>>+      u_int8_t bitmask;
>>+};
>
> As per the "Writing Netfilter modules" e-book, __u16/__u8 is required.

Done.

>>+config NETFILTER_XT_MATCH_IPVS
>>+      tristate '"ipvs" match support'
>>+      depends on NETFILTER_ADVANCED
>>+      help
>>+        This option allows you to match against ipvs properties of a packet.
>>+
>>+          To compile it as a module, choos M here.  If unsure, say N.
>>+
>IMHO the "to compile it as a module, choos[e] M" is a relict from
> old times and should just be dropped. These days, I stupilate,
> everyone knows that M makes modules. And if it doesnot, then
> it's not allowed by Kconfig :>

Done.

>>+MODULE_AUTHOR("Hannes Eder <heder@google.com>");
>>+MODULE_DESCRIPTION("Xtables: match ipvs");
>
> "Match IPVS connection properties" is what you previously stated,
> and which I think is good. Use it here, too.

Done.

>>+bool ipvs_mt(const struct sk_buff *skb, const struct xt_match_param *par)
>>+{
>>+      const struct xt_ipvs *data = par->matchinfo;
>>+      const u_int8_t family = par->family;
>>+      struct ip_vs_iphdr iph;
>>+      struct ip_vs_protocol *pp;
>>+      struct ip_vs_conn *cp;
>>+      int af;
>>+      bool match = true;
>>+
>>+      if (data->bitmask == XT_IPVS_IPVS) {
>>+              match = !!(skb->ipvs_property)
>>+                      ^ !!(data->invert & XT_IPVS_IPVS);
>>+              goto out;
>>+      }
>
> XT_IPVS_IPVS? What's that supposed to tell me...

Just matching aginst the skb->ipvs_property, I changed to name to
XT_IPVS_IPVS_PROPERTY.

> Anyway, this can be made much shorter, given that all following
> the "out" label is a return:

You are right.  For the moment, I'll keep it as is.  Having a single
entry/exit point makes it easier to instrument the function for
debugging.

>
>        if (data->bitmask == XT_IPVS_IPVS)
>                return skb->ipvs_property ^ !!(data->invert & XT_IPVS_IPVS);
>
>>+      /* other flags than XT_IPVS_IPVS are set */
>>+      if (!skb->ipvs_property) {
>>+              match = false;
>>+              goto out;
>>+      }
>
>        if (!skb->ipvs_property)
>                return false;
>
>>+      ip_vs_fill_iphdr(af, skb_network_header(skb), &iph);
>>+
>>+      if (data->bitmask & XT_IPVS_PROTO)
>>+              if ((iph.protocol == data->l4proto)
>>+                  ^ !(data->invert & XT_IPVS_PROTO)) {
>>+                      match = false;
>>+                      goto out;
>>+              }
>
>                if (iph.protocol == data->l4proto ^
>                    !(data->invert & XT_IPVS_PROTO))
>                        return false;
>
>>+      pp = ip_vs_proto_get(iph.protocol);
>>+      if (unlikely(!pp)) {
>>+              match = false;
>>+              goto out;
>>+      }
>
>        if (unlikely(pp == NULL))
>                return false;
>
> Only after here we really need goto (to put pp).
>
>>+      /*
>>+       * Check if the packet belongs to an existing entry
>>+       */
>>+      /* TODO: why does it only match in inverse? */
>
> FIXME: Figure it out :)

Still working on that ;)

>>+      cp = pp->conn_out_get(af, skb, pp, &iph, iph.len, 1 /* inverse */);
>>+      if (unlikely(!cp)) {
>>+              match = false;
>>+              goto out;
>>+      }
>>+
>>+      /*
>>+       * We found a connection, i.e. ct != 0, make sure to call
>>+       * __ip_vs_conn_put before returning.  In our case jump to out_put_con.
>>+       */
>>+
>>+      if (data->bitmask & XT_IPVS_VPORT)
>>+              if ((cp->vport == data->vport)
>>+                  ^ !(data->invert & XT_IPVS_VPORT)) {
>>+                      match = false;
>>+                      goto out_put_ct;
>>+              }
>>+
>>+      if (data->bitmask & XT_IPVS_DIR) {
>>+              /* TODO: implement */
>
>                /* Yes please */

Here we go:

	if (data->bitmask & XT_IPVS_DIR) {
		enum ip_conntrack_info ctinfo;
		struct nf_conn *ct = nf_ct_get(skb, &ctinfo);

		if (ct == NULL || ct == &nf_conntrack_untracked) {
			match = false;
			goto out_put_cp;
		}

		if ((ctinfo >= IP_CT_IS_REPLY) ^
		    !!(data->invert & XT_IPVS_DIR)) {
			match = false;
			goto out_put_cp;
		}
	}

>>+      }
>>+
>>+      if (data->bitmask & XT_IPVS_METHOD)
>>+              if (((cp->flags & IP_VS_CONN_F_FWD_MASK) == data->fwd_method)
>>+                  ^ !(data->invert & XT_IPVS_METHOD)) {
>>+                      match = false;
>>+                      goto out_put_ct;
>>+              }
>>+
>>+      if (data->bitmask & XT_IPVS_VADDR) {
>>+              if (af != family) {
>>+                      match = false;
>>+                      goto out_put_ct;
>>+              }
>>+
>>+              if (ipvs_mt_addrcmp(&cp->vaddr, &data->vaddr, &data->vmask, af)
>>+                  ^ !(data->invert & XT_IPVS_VADDR)) {
>
> I think the operator (^ in this case) always goes onto the same line as the ')'
> ((a) ^\n(b), not ((a)\n ^(b)), though some legacy code seems to do it
> random so-so.)

I changed it as suggested, though I could not find anything in
Documentation/CodingStyle about that.

>>+      return match;
>>+}
>>+EXPORT_SYMBOL(ipvs_mt);
>
> What will be using ipvs_mt?

Nobody, EXPORT_SYMBOL removed.

>>+static struct xt_match xt_ipvs_mt_reg[] __read_mostly = {
>>+      {
>>+              .name       = "ipvs",
>>+              .revision   = 0,
>>+              .family     = NFPROTO_UNSPEC,
>>+              .match      = ipvs_mt,
>>+              .matchsize  = sizeof(struct xt_ipvs),
>>+              .me         = THIS_MODULE,
>>+      },
>>+};
>
> There is just one element, so no strict need for the [] array.

You are right.  Done.

Thanks for the review.

Cheers,
-Hannes
