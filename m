Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899Ab0ALJTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab0ALJTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 04:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865Ab0ALJTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 04:19:11 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:46488 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154Ab0ALJTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 04:19:10 -0500
X-Greylist: delayed 1785 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jan 2010 04:19:09 EST
Message-ID: <4B4C376C.6080705@st.com>
Date: Tue, 12 Jan 2010 09:48:44 +0100
From: Francesco VIRLINZI <francesco.virlinzi@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC,PATCH 1/7 v2] Add a common struct clk
References: <1263279511.160551.332624337260.1.gpush@pororo>
In-Reply-To: <1263279511.160551.332624337260.1.gpush@pororo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy
In November I already sent a proposal on
  a generic linux clk framework.
On that I would suggest:

>
> +struct clk {
> +	const struct clk_operations *ops;
>    
            spinlock_t lock;
            const char *name;
            int id;
            unsigned long rate;
> +};
> +
> +struct clk_operations {
>    
                int (*init)(struc clk *);
> +       int             (*enable)(struct clk *);
> +       void            (*disable)(struct clk *);
> +       unsigned long   (*get_rate)(struct clk *);
> +       void            (*put)(struct clk *);
> +       long            (*round_rate)(struct clk *, unsigned long);
> +       int             (*set_rate)(struct clk *, unsigned long);
> +       int             (*set_parent)(struct clk *, struct clk *);
> +       struct clk*     (*get_parent)(struct clk *);
> +};
>    

+static inline int clk_enable(struct clk *clk)
+{
	unsigned long flags;
	int ret = 0;
+	if (clk->ops->enable) {
		spinlock_irq_save(&clk->lock, flags);
+		ret = clk->ops->enable(clk);
		spinlock_irq_restore(&clk->lock, flags);
	}
+	return 0;
+}

Something similar in the other function...

> +
> +static inline unsigned long clk_get_rate(struct clk *clk)
> +{
> +	if (clk->ops->get_rate)
> +		return clk->ops->get_rate(clk);
>    
> 	return clk->rate;
> +}
>
>    
Moreover if you support .set_parent and .get_parent  a .parent field in 
the struct clk
  is useful.

As

struct clk {
const struct clk_operations *ops;

     spinlock_t lock;
     const char *name;
     int id;
     unsigned long rate;
     struct clk *parent;
};

Regards
  Francesco
