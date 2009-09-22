Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbZIVATT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbZIVATT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 20:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbZIVATT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 20:19:19 -0400
Received: from smtp-out.google.com ([216.239.33.17]:12597 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbZIVATS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 20:19:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=MLt3KlmofAsO7nikBec1yDkC6ox5qOJOKbauRUPqiULZVsu0vMHGw1bEZQgVnG+LY
	NUe9C3+asdJsgaQMyeJSA==
Date: Mon, 21 Sep 2009 17:19:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       sachinp@in.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [RFC PATCH 0/3] Fix SLQB on memoryless configurations V2
In-Reply-To: <1253577603.7103.174.camel@pasglop>
Message-ID: <alpine.DEB.1.00.0909211704180.4798@chino.kir.corp.google.com>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie> <1253577603.7103.174.camel@pasglop>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009, Benjamin Herrenschmidt wrote:

> So if I understand correctly, we have a problem with both cpu-less and
> memory-less nodes. Interesting setups :-)
> 

I agree with Christoph that we need to resolve the larger kernel issue of 
memoryless nodes in the kernel and the result of that work will most 
likely become the basis from which the slqb fixes originate.

I disagree that we need kernel support for memoryless nodes on x86 and 
probably on all architectures period.  "NUMA nodes" will always contain 
memory by definition and I think hijacking the node abstraction away from 
representing anything but memory affinity is wrong in the interest of a 
long-term maintainable kernel and will continue to cause issues such as 
this in other subsystems.

I do understand the asymmetries of these machines, including the ppc that 
is triggering this particular hang with slqb.  But I believe the support 
can be implemented in a different way: I would offer an alternative 
representation based entirely on node distances.  This would isolate each 
region of memory that has varying affinity to cpus, pci busses, etc., into 
nodes and then report a distance, whether local or remote, to other nodes 
much in the way the ACPI specification does with proximity domains.

Using node distances instead of memoryless nodes would still be able to 
represent all asymmetric machines that currently benefit from the support 
by binding devices to memory regions to which they have the closest 
affinity and then reporting relative distances to other nodes via 
node_distance().
