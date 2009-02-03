Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZBCCLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZBCCLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 21:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZBCCL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 21:11:28 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:23569 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751367AbZBCCL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 21:11:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wEexDrFJujQEfr7VO3/OCL8usYzc1g4hDv3a177hh7qBO5yGY4jalqz5QX65zhm9o2fsPFm+urdPF1EVdF0dAQRirhYhSEVSCLPxNVlhd6/Z+SpqGpyH2zciWXUuCOEYuXjMR3mDvW1QAeCcfa+uvUqTboKuw0SnJ40zPP49W5k=  ;
X-YMail-OSG: i90phToVM1kRODaTHhZ9Rb80J483I89WDK9Knmv.TKCHCAPSA7pf44jcfhxBXlBV.HEpkzUc3IHTOQggGu7gKF4qsIpvn6v4mLYDNb1Dk.4lLN0hsYfzjgCv0DGudmplIfy4Epfvl3NfF1VW3xnGvrrsd.kqiCRxduYjWwtSMXTKmHOlNmpSd0vqFPWpYg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: Commit 31a12666d8f0c22235297e1c1575f82061480029 slows down Berkeley DB
Date: Tue, 3 Feb 2009 13:11:01 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       npiggin@suse.de
References: <20090130012315.GB19554@duck.suse.cz> <200902031224.20856.nickpiggin@yahoo.com.au> <1233626066.2604.114.camel@ymzhang>
In-Reply-To: <1233626066.2604.114.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031311.02378.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009 12:54:26 Zhang, Yanmin wrote:
> On Tue, 2009-02-03 at 12:24 +1100, Nick Piggin wrote:
> > On Friday 30 January 2009 12:23:15 Jan Kara wrote:
> > >   Hi,
> > >
> > >   today I found that commit 31a12666d8f0c22235297e1c1575f82061480029
> > > (mm: write_cache_pages cyclic fix) slows down operations over Berkeley
> > > DB. Without this "fix", I can add 100k entries in about 5 minutes 30s,
> > > with that change it takes about 20 minutes.
> > >   What is IMO happening is that previously we scanned to the end of
> > > file, we left writeback_index at the end of file and went to write next
> > > file. With the fix, we wrap around (seek) and after writing some more
> > > we go to next file (seek again).
>
> We also found this commit causes about 40~50% regression with iozone
> mmap-rand-write. #iozone -B -r 4k -s 64k -s 512m -s 1200m
>
> My machine has 8GB memory.

Ah, thanks. Yes BDB I believe is basically just doing an mmap-rand-write,
so maybe this is a good test case.

The interesting thing is why is this causing such a slowdown. If there is
only a single main file active in the workload, then I don't see why this
patch should make such a big difference. In either case, wouldn't pdflush
come back and just start writing out from the start of the file anyway?

