Return-Path: <linux-kernel-owner+w=401wt.eu-S1761092AbYB1QTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761092AbYB1QTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbYB1QTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:19:08 -0500
Received: from mail153.messagelabs.com ([216.82.253.51]:51816 "HELO
	mail153.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754707AbYB1QTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:19:07 -0500
X-VirusChecked: Checked
X-Env-Sender: Steve.Hawkes@motorola.com
X-Msg-Ref: server-10.tower-153.messagelabs.com!1204215545!2842182!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [144.189.100.105]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: printk_ratelimit and net_ratelimit conflict and tunable behavior
Date: Thu, 28 Feb 2008 10:19:02 -0600
Message-ID: <7BFDACCD6948EF4D8FE8F4888A91596A01637208@tx14exm60.ds.mot.com>
In-Reply-To: <20080225154521.e119cbb6.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: printk_ratelimit and net_ratelimit conflict and tunable behavior
Thread-Index: Ach4CLRvWBZOoz9RT0y3jYcPpF+S6gCHLD0Q
References: <200802252036.m1PKaeMY012587@ftw.mot.com> <20080225154521.e119cbb6.akpm@linux-foundation.org>
From: "Hawkes Steve-FSH016" <Steve.Hawkes@motorola.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <davem@davemloft.net>, <joe@perches.com>, <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> This patch causes a large and nasty reject.
> Probably because you patched 2.6.24.  We're developing 2.6.25 now, and
> the difference between the two is very large inded.  Please raise
patches
> against Linus's latest tree?

Will do. I'm learning the process. I assume Linus's latest tree is the
one
listed as the latest prepatch for the stable Linux kernel tree.

Andrew Morton wrote:

> > struct printk_ratelimit_state {
> > +	unsigned long toks;
> > +	unsigned long last_jiffies;
> > +	int missed;
> > +	int limit_jiffies;
> > +	int limit_burst;
> > +	char const *facility;
> > +};
> 
> I find that the best-value comments one can add to kernel code are to
the
> members of structures.  If the reader understands what all the fields
do, the
> code becomes simple to follow.

Agreed. Although the current kernel source doesn't document these
attributes, there's no reason I couldn't add documentation for them.

Andrew Morton wrote:

> >  int net_ratelimit(void)
> >  {
> > -	return __printk_ratelimit(net_msg_cost, net_msg_burst);
> > +	static struct printk_ratelimit_state limit_state = {
> > +		.toks          = 10 * 5 * HZ,
> > +		.last_jiffies  = 0,
> > +		.missed        = 0,
> > +		.limit_jiffies = 5 * HZ,
> > +		.limit_burst   = 10,
> > +		.facility      = "net"
> > +	};
> > +
> > +	return __printk_ratelimit(net_msg_cost, net_msg_burst,
&limit_state);
> 
> I don't get it.  There's one instance of limit_state, kernel-wide, and
> __printk_ratelimit() modifies it.  What prevents one CPU's activities
from
> interfering with a second CPU's activities?

The state is protected by the spinlock in __printk_ratelimit, like it is
in
the current kernel. Am I missing something?
