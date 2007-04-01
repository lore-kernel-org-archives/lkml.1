Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbXDAGQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbXDAGQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 02:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932566AbXDAGQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 02:16:26 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38668 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbXDAGQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 02:16:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jurriaan <thunder7@xs4all.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@in.ibm.com>
Subject: Re: 2.6.21-rc5-mm3 - no boot, "address not 2M aligned"
References: <20070330010559.2a232d9a.akpm@linux-foundation.org>
	<20070331071220.GA26910@aitel.hist.no>
	<20070331005303.354411f0.akpm@linux-foundation.org>
	<20070401052932.GA9894@amd64.of.nowhere>
Date: Sun, 01 Apr 2007 00:15:51 -0600
In-Reply-To: <20070401052932.GA9894@amd64.of.nowhere> (thunder7@xs4all.nl's
	message of "Sun, 1 Apr 2007 07:29:32 +0200")
Message-ID: <m1ircghb6w.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thunder7@xs4all.nl writes:

> I had the same with this .config from 2.6.21-rc3-mm2 after running 'make
> oldconfig' and answering N to all new questions. Then, I tweaked some
> items, mostly to see if there was an 'align kernel' item in there
> somewhere. Diff between _working_ 2.6.21-rc5-mm3 .config and this
> 2.6.21-rc3-mm2 .config at the end. Somehow that seems to have adapted
> 'CONFIG_PHYSICAL_START', maybe that's it?

That looks like it.

Does anyone know how to express the constraint of a 2M aligned number in Kconfig?

The original plan was to remove CONFIG_PHYSICAL_START and CONFIG_RELOCATABLE on
x86_64 because after this series they have no cost and thus just lead to a little
more confusion.

However because we don't tag vmlinux as ET_DYN and Xen has some use for kernel
built at different physical addresses (or at least loaded at them), and because
Xen directly loads vmlinux he kept those options.

If we can find a place to stick it into the build doing a little post processing
of vmlinux so that it has the proper ELF header type (ET_DYN not ET_EXEC) would
be useful and allow us to remove those extra confusing options.

If I have a spare moment I will take a look.  Since there is confusion it is
probably worth removing the unnecessary confusing options if we can instead
of supporting the full confusion.

Doing the same for i386 would be a little harder but with Dave
Miller's suggestions for Xen and leaving the functions to be replaced
unlinked so the compiler generates efficient calls and then doing
linking magic to fill in the pieces at boot looks about as tricky as
moving the relocation logic for i386 into vmlinux as well.  So it
seems feasible and possibly worth doing.

Eric
