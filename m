Return-Path: <linux-kernel-owner+w=401wt.eu-S934431AbYEBSun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934431AbYEBSun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbYEBSud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:50:33 -0400
Received: from relay1.sgi.com ([192.48.171.29]:44496 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756097AbYEBSuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:50:32 -0400
Date: Fri, 2 May 2008 13:50:30 -0500
From: Russ Anderson <rja@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 3/3] ia64: Call migration code on correctable errors v2
Message-ID: <20080502185030.GH7246@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080502004425.GD12006@sgi.com> <87fxt0vbu4.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fxt0vbu4.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 07:45:55PM +0200, Andi Kleen wrote:
> Russ Anderson <rja@sgi.com> writes:
> 
> > Migrate data off pages with correctable memory errors.  This patch is the 
> > ia64 specific piece.  It connects the CPE handler to the page migration
> > code.  It is implemented as a kernel loadable module, similar to the mca
> > recovery code (mca_recovery.ko).  This allows the feature to be turned off
> > by uninstalling the module.  Creates /proc/badram to display bad page
> > information and free bad pages.
> 
> How do you know what pages have excessive errors? And how is excessive defined?
> Surely you don't keep  a per page error count? It's unclear from your patch. 

The code migrates on the first correctable error on a page, so "excessive"
is one.  Yes, keeping a per page count gets problematic, especially as
memories get larger.  The issue of the right metric for when to migrate
will always be debatable and the "right" answer likely will depend on
the physical memory technology.

> Anyways I don't think this should be ia64 specific, but generic code.

The actual migration code is generic, in mm/migrate.c.

The ia64 kernel module piece is very arch specific.  It ties into the 
ia64 CPE handler.  It gets the page address from the CPE record, based
on the ia64 error handling spec.  Each arch will have a different way of
determining the physical address of the correctable error (for example).

> I also have my doubts about making such small code subsystems modules. Modules
> always get rounded to pages so it ultimatively just wastes memory.

CONFIG_IA64_CPE_MIGRATE=m builds it as module.
CONFIG_IA64_CPE_MIGRATE=y builds it as part of the kernel.

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
