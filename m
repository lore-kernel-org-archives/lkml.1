Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbZHEUXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbZHEUXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 16:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZHEUXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 16:23:44 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:33355
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbZHEUXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 16:23:44 -0400
X-IronPort-AV: E=Sophos;i="4.43,330,1246831200"; 
   d="scan'208";a="44374733"
Message-ID: <4A79EA5A.7040308@inria.fr>
Date: Wed, 05 Aug 2009 22:23:54 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 0/5 v4] x86: Adapt CPU topology detection for AMD Magny-Cours
References: <20090805154402.GA6520@alberich.amd.com>
In-Reply-To: <20090805154402.GA6520@alberich.amd.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
> Changes to previous patch set:
> - fixed allnoconfig compile error and link error if CONFIG_PCI=n
> - fixed hotplug issue: cpumask of siblings sharing same L3 were not
>   properly updated
> - properly allocate cpu_node_map
>
> Current patch set contains 5 patches:
> - patch 1 adapts common code to show cpu_node_id,
>   cpu_node_siblings and cpu_node_siblings_list in
>   /sys/devices/system/cpu/cpu*/topology
> - patch 2 prepares arch/x86 to provide cpu_node information
> - patch 3 sets up cpu_node information for AMD Magny-Cours CPU
> - patch 4 fixes L3 cache information for Magny-Cours
> - patch 5 fixes mcheck code for Magny-Cours
>   

Hello Andreas,

Reading your first submission I find something disturbing. You say that
we'll have the following sibling information:

  Level        | Set of CPUs
 --------------|---------------
  phys_package | core_siblings
  cpu_node     | cpu_node_siblings
  core         | thread_siblings
  thread       | one CPU


This breaks the existing convention/semantics. Currently
core/thread_siblings contains the cpumask covering *all* siblings of
current core/thread object. What you're adding only shows the cpumask of
current "cpu_node" object in cpu_node_siblings. I don't have any
preference between both semantics, but I think "cpu_node" should use the
semantics that "core" and "thread" do. So the above should be changed into:

  Level        | Set of CPUs
 --------------|---------------
  phys_package | cpu_node_siblings
  cpu_node     | core_siblings
  core         | thread_siblings
  thread       | one CPU


Brice

