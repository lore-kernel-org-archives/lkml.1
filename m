Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbZJ1SjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbZJ1SjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 14:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbZJ1SjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 14:39:03 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:48934 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbZJ1SjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 14:39:02 -0400
Date: Wed, 28 Oct 2009 12:39:05 -0600
From: Alex Chiang <achiang@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Badari Pulavarty <pbadari@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 1/5] mm: add numa node symlink for memory section in
	sysfs
Message-ID: <20091028183905.GF22743@ldl.fc.hp.com>
References: <20091022040814.15705.95572.stgit@bob.kio> <20091022041510.15705.5410.stgit@bob.kio> <alpine.DEB.2.00.0910221249030.26631@chino.kir.corp.google.com> <20091027195907.GJ14102@ldl.fc.hp.com> <alpine.DEB.2.00.0910271422090.22335@chino.kir.corp.google.com> <20091028083137.GA24140@osiris.boeblingen.de.ibm.com> <alpine.DEB.2.00.0910280159380.7122@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910280159380.7122@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Rientjes <rientjes@google.com>:
> 
> Alex, I think the safest thing to do in unregister_mem_sect_under_nodes() 
> is to iterate though the section pfns and remove links to the node_device 
> kobjs for all the distinct pfn_to_nid()'s that it encounters.

Am I not understanding the code? It looks like we do this
already...

/* unregister memory section under all nodes that it spans */
int unregister_mem_sect_under_nodes(struct memory_block *mem_blk)
{
	nodemask_t unlinked_nodes;
	unsigned long pfn, sect_start_pfn, sect_end_pfn;

	if (!mem_blk)
		return -EFAULT;
	nodes_clear(unlinked_nodes);
	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
		int nid;

		nid = get_nid_for_pfn(pfn);
		if (nid < 0)
			continue;
		if (!node_online(nid))
			continue;
		if (node_test_and_set(nid, unlinked_nodes))
			continue;
		sysfs_remove_link(&node_devices[nid].sysdev.kobj,
			 kobject_name(&mem_blk->sysdev.kobj));
		sysfs_remove_link(&mem_blk->sysdev.kobj,
			 kobject_name(&node_devices[nid].sysdev.kobj));
	}
	return 0;
}

Thanks,
/ac

