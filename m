Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYGKMR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYGKMR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbYGKMRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:17:46 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47376 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYGKMRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:17:45 -0400
Date: Fri, 11 Jul 2008 06:17:44 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com
Subject: Re: Multiple MSI, take 3
Message-ID: <20080711121744.GT14894@parisc-linux.org>
References: <20080711005719.GO14894@parisc-linux.org> <m1iqvc91li.fsf@frodo.ebiederm.org> <20080711102326.GR14894@parisc-linux.org> <m1iqvc7iys.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1iqvc7iys.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 04:34:19AM -0700, Eric W. Biederman wrote:
> There is one idea that seems to model this cleanly
> without breaking all kinds of expectations.
> 
> That is an irq with a very small data payload.
> 
> In that case we wire all of the vectors up to a single
> irq handler that computes the payload as:
> payload = vector - base-vector.
> 
> And then we figure out how to pass that to the handler in irqaction.
> 
> To most of the system it is a single irq so it avoids breaking
> expectations about what an irq is.
> 
> To everything else it is a little odd, and has it's own unique
> set of rules (which is good as well).

OK, I'm willing to play this scenario through and see where it takes us.

 - The affinity now matches reality.  Good.
 - For devices without individual masking, the masking API matches
   reality.  Good.
 - For devices with individual masking, we'll want a new API.  Adequate.
 - We'll still need to allocate an aligned block of vectors on x86-64.
   No change.

I think rather than passing the 'vector - base_vector' integer, the
request_irq_block() should pass in an array of pointers as large as nvec
and irqaction passes the appropriate pointer to the handler.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
