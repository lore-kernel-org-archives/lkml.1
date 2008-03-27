Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbYC0Xi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbYC0Xi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 19:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYC0Xip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 19:38:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:14510 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbYC0Xio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 19:38:44 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Ilpo =?iso-8859-1?q?J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: Re: [PATCH 3/7] [NET]: uninline dev_alloc_skb, de-bloats a lot
Date: Fri, 28 Mar 2008 00:36:59 +0100
User-Agent: KMail/1.8.2
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>
References: <1206621486-5408-1-git-send-email-ilpo.jarvinen@helsinki.fi> <1206621486-5408-3-git-send-email-ilpo.jarvinen@helsinki.fi> <1206621486-5408-4-git-send-email-ilpo.jarvinen@helsinki.fi>
In-Reply-To: <1206621486-5408-4-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803280036.59311.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 March 2008 13:38, Ilpo Järvinen wrote:
> Allyesconfig (v2.6.24-mm1):
> 
> -23668  392 funcs, 104 +, 23772 -, diff: -23668 --- dev_alloc_skb
> 
> Without many debug CONFIGs (v2.6.25-rc2-mm1):
> 
> -12178  382 funcs, 157 +, 12335 -, diff: -12178 --- dev_alloc_skb
> dev_alloc_skb                 |  +37


This will be very confusing for casual reader:

> +struct sk_buff *dev_alloc_skb(unsigned int length)
> +{
> +	return __dev_alloc_skb(length, GFP_ATOMIC);
> +}
> +EXPORT_SYMBOL(dev_alloc_skb);

"what, they want to save one push instruction per callsite??".

Can you add a comment which explains the intent?

+struct sk_buff *dev_alloc_skb(unsigned int length)
+{
+       /* There is more code here than it seems:
+        * __dev_alloc_skb is an inline */
+	return __dev_alloc_skb(length, GFP_ATOMIC);
+}
+EXPORT_SYMBOL(dev_alloc_skb);


Another good chunk of code size saving can be achieved
by introducing dev_alloc_skb_or_warn(), and using it
in places like these:

drivers/net/irda/nsc-ircc.c:

                        skb = dev_alloc_skb(len+1);
                        if (skb == NULL)  {
                                IRDA_WARNING("%s(), memory squeeze, "
                                             "dropping frame.\n",
                                             __FUNCTION__);

drivers/net/appletalk/ltpc.c:

        skb = dev_alloc_skb(3+sklen);
        if (skb == NULL)
        {
                printk("%s: dropping packet due to memory squeeze.\n",

net/econet/af_econet.c:

        newskb = alloc_skb((len - sizeof(struct aunhdr) + 15) & ~15,
                           GFP_ATOMIC);
        if (newskb == NULL)
        {
                printk(KERN_DEBUG "AUN: memory squeeze, dropping packet.\n");
                /* Send nack and hope sender tries again */
                goto bad;
        }

(hmm, this last one also wants s/alloc_skb(GFP_ATOMIC)/dev_alloc_skb/)

--
vda
