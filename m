Return-Path: <linux-kernel-owner+w=401wt.eu-S1752285AbZCJEGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbZCJEGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 00:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbZCJEGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 00:06:33 -0400
Received: from waste.org ([66.93.16.53]:50604 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbZCJEGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 00:06:32 -0400
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
From: Matt Mackall <mpm@selenic.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Paul Menage <menage@google.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0903091853000.25296@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0903091448110.20314@qirst.com>
	 <alpine.DEB.2.00.0903091307570.27253@chino.kir.corp.google.com>
	 <20090310102926.A47E.A69D9226@jp.fujitsu.com>
	 <alpine.DEB.2.00.0903091853000.25296@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 23:05:54 -0500
Message-Id: <1236657954.4192.523.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 19:01 -0700, David Rientjes wrote:
> On Tue, 10 Mar 2009, KOSAKI Motohiro wrote:
> 
> > That's pointless.
> > Again, any fastpath modification should have reasonable reason.
> > We are looking for your explanation.
> > 
> 
> The fastpath modification simply checks if the hardwall bit is set in the 
> allocating task's cpuset flags.  If it's disabled, there is no additional 
> overhead.

Ok, I for one understand perfectly the desire for this feature.

But we are still extremely sensitive to adding potential branches to one
of the most important fast-paths in the kernel, especially for a feature
with a fairly narrow use case. We've invested an awful lot of time into
micro-optimizing SLAB (by rewriting it as SLUB/SLQB) so any steps
backward at this stage are cause for concern. Also, remember 99%+ of
users will never care about this feature.

For SLOB, I think the code is fine as it stands, but we probably want to
be a bit more clever for the others. At the very minimum, we'd like this
to be in an unlikely path. Better still if the initial test can somehow
be hidden with another test. It might also be possible to use the
patching code used by markers to enable the path only when one or more
tasks needs it.

-- 
http://selenic.com : development and support for Mercurial and Linux


