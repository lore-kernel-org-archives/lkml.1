Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbXJZW6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbXJZW6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbXJZW6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:58:32 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:49523 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbXJZW6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:58:31 -0400
To: "Ph. Marek" <philipp.marek@bmlv.gv.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Exporting a lot of data to other processes?
References: <200710250805.33369.philipp.marek@bmlv.gv.at>
From: Nix <nix@esperi.org.uk>
Emacs: because Hell was full.
Date: Fri, 26 Oct 2007 23:58:25 +0100
In-Reply-To: <200710250805.33369.philipp.marek@bmlv.gv.at> (Ph. Marek's message of "25 Oct 2007 06:06:13 -0000")
Message-ID: <87zly5lbzi.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-wuwien-Metrics: hades 1290; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 Oct 2007, Ph. Marek told this:
> -) use some ramfs/shmfs or similar, and overwrite the data occasionally
>    - not current data
>    - runtime overhead (processor load)

This is roughly what the nscd implementation in glibc does: the client
can work over a socket, but prefers to ask the daemon for a file
descriptor to an mmap()ed copy of the database. Then it works from that.

Properly done this is as efficient as working in the local process, with
only context switch overhead involved, and even that only when the
database is being updated. You *do* have to think about proper locking
of some kind, perhaps by designing the data structure in the shared
mmap()ed region appropriately.

(nscd has an ill-deserved reputation for sloth and memory-hungriness.
This is probably caused by bad experiences with old Solaris nscds, which
were quite appallingly inefficient. glibc nscd manages to speed up
passwd lookups even if your passwd database is only about ten lines
long, simply by amortizing the parsing overhead... and the nscd process
itself incurs *no* CPU overhead except as needed to reparse and update
the database, which is overhead that would otherwise be duplicated in
every process that did service parsing. As for memory hungriness, well,
yes, it looks like nscd is huge, but it's a huge *sparse* mmap()ed
block, so doesn't actually consume more than a few hundred Kb, not the
dozens of Mb it looks like in ps(1).)

-- 
`Some people don't think performance issues are "real bugs", and I think 
such people shouldn't be allowed to program.' --- Linus Torvalds
