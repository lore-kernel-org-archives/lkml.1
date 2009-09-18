Return-Path: <linux-kernel-owner+w=401wt.eu-S1751879AbZIRNhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbZIRNhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 09:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbZIRNhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 09:37:04 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:34932 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZIRNhD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 09:37:03 -0400
X-SpamScore: -16
X-BigFish: VPS-16(z1f98jz1432R98dN148cMzz1202hzzz32i203h6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KQ65SI-04-2JX-02
X-M-MSG: 
Date: Fri, 18 Sep 2009 15:36:22 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Jan Beulich <JBeulich@novell.com>
CC: dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: amd64_edac making improper assumptions?
Message-ID: <20090918133622.GB25309@aftab>
References: <4AB3A1040200007800015BD3@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4AB3A1040200007800015BD3@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Sep 2009 13:36:17.0562 (UTC) FILETIME=[FFF51FA0:01CA3864]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On Fri, Sep 18, 2009 at 02:02:28PM +0100, Jan Beulich wrote:
> Doug, Borislav,
> 
> the sizing of pvt_lookup[] and mci_lookup[] is done based on a config
> setting (CONFIG_NODES_SHIFT), and the indexing happens using the
> raw value read from hardware without any bounds checking. Hence,
> running a kernel with e.g. !CONFIG_NUMA on a multi-socket system
> would happily access other than the first and only array element.

Good catch, will fix, thanks. See below for longer explanation.

> Likewise, the use of rdmsr_on_cpu() doesn't seem to do what is
> intended when !CONFIG_NUMA.
> 
> Also, assuming you can use cpumask_of_node() directly on the
> node ID read from hardware seems bogus (even in general, but
> namely again when MAX_NUMNODES is less than the actual number
> of nodes).

originally, the driver was compiling in NUMA for facilities like
cpumask_of_node() et al for all per-node stuff but Ingo raised a concern
that the NUMA dependency shouldn't be needed. Therefore, we needed some
alternative facilities which, for example, can give you all the cores
on a node so that you can init a driver instance per node and thus per
memory controller.

Well, Andreas did prepare a bunch of generic cpu topology patches which
handle also MCM processors (e.g. having more than one internal node) and
currently the per-CPU cpu_llc_id var contains the node id of a cpu. They
went upstream last week and I'm waiting for another patch in -tip to go
in before I send my local queue here which removes the cpumask_of_node()
usage and all the rest of NUMA stuff completely.

Hope that makes it more clear and thanks for letting us know, we're on
it :).

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

