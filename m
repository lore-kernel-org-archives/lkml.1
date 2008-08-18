Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbYHRR5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbYHRR5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbYHRR5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:57:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbYHRR5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:57:18 -0400
Subject: Re: [malware-list] scanner interface proposal was: [TALPA]
	Intro	to a linux interface for on access scanning
From: Eric Paris <eparis@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: tvrtko.ursulin@sophos.com, Theodore Tso <tytso@mit.edu>, davecb@sun.com,
       david@lang.hm, Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20080818182556.13ced58f@lxorguk.ukuu.org.uk>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>
	 <1219076143.15566.39.camel@localhost.localdomain>
	 <20080818171500.78590801@lxorguk.ukuu.org.uk>
	 <1219080504.15566.65.camel@localhost.localdomain>
	 <20080818182556.13ced58f@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 13:54:57 -0400
Message-Id: <1219082097.15566.82.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 18:25 +0100, Alan Cox wrote:
> > I think I'm going to stick with my special file in securityfs since it
> > makes it some simple to install the fd in the scanning process (as
> > opposed to netlink where I don't even know how it would be possible...)
> 
> AF_UNIX passes file handles just fine. I'm not sure netlink will help you
> here anyway - isn't it lossy under load ?

But the file being installed needs to be at least RD for AV/Indexer.
Particularly of interest to people here would be a file opened O_WRONLY
and then the indexer wouldn't have the ability to read the data that was
just written.  So we need a new FD, can't just send the old one.

I'd also assume that an HSM would need a WR file descriptor, which isn't
easy.  I've found that (through trial and error not understanding the
code) trying to make new descriptors for the new process have WR often
returned with ETXTBUSY....

I think I might just give RO file descriptors and if an HSM comes along
work with them to get WR fd's working....

> Also securityfs is more special purpose magic here - what does it have to
> do with a general purpose notifier API ? I'd actually generalise the
> notifier properly and go for a syscall.

Well, securityfs is really just a location for a bunch of interfaces.
The real 'magic' is that I defined my own read and write functions on a
special inode.

Lets assume a new syscall (and I know you tried to describe this too me
before but I can't remember it and I'm having some e-mail history
trouble) what would it look like?  A scanner constantly calls scan() to
block for data to be scanned?  So an AV, HSM, or indexer all would be
blocking in scan() just waiting for data?  How do they respond?  How is
it better, cleaner, or more general than a 'special' file they
read/write?

-Eric

