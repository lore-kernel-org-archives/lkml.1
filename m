Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092AbXLJFD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbXLJFD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 00:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbXLJFDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 00:03:19 -0500
Received: from ns1.suse.de ([195.135.220.2]:53790 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbXLJFDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 00:03:17 -0500
From: Neil Brown <neilb@suse.de>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Mon, 10 Dec 2007 16:03:10 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18268.51342.353887.178014@notabene.brown>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, gnome42@gmail.com,
       linux-kernel@vger.kernel.org, bfields@fieldses.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Denis V. Lunev" <den@openvz.org>
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
In-Reply-To: message from Maxim Levitsky on Sunday December 9
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>
	<20071207151444.af5d8e11.akpm@linux-foundation.org>
	<200712080043.29292.rjw@sisk.pl>
	<200712090220.44543.maximlevitsky@gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday December 9, maximlevitsky@gmail.com wrote:
> On Saturday 08 December 2007 01:43:28 Rafael J. Wysocki wrote:
> > On Saturday, 8 of December 2007, Andrew Morton wrote:
> > > On Fri, 07 Dec 2007 17:51:58 -0500
> > > Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > > 
> > > > 
> > > > On Fri, 2007-12-07 at 14:39 -0500, Shane wrote:
> > > > > On Dec 7, 2007 2:16 PM, Shane <gnome42@gmail.com> wrote:
> > > > > ...
> > > > > > Confirmed working in rc4-git5.  I'll deploy this kernel in a few more
> > > > > > spots and check for other regressions.
> > > > > 
> > > > > Hmm, I installed a new kernel built from the same sources on the NFS
> > > > > server. And now I don't see anything at all in the crossmnt dirs.
> > > > > 
> > > > > ls /dirA/dirB/dirC  --> zero output (empty dir)
> > > > > 
> > > > > Are there any other pending fixes?
> 
> Hi,
> Due to the fact that I was bitten by this bug (I thought it is a feature), and a bit of lack
> of understanding of NFS4 I want to ask few questions about NFS:
> 
> 1) I want to export whole file-system  with submounts to a range of clients.
> As 'exports' manual says I can't do so, is that true?

You should be able to do this successfully with nfs-utils 1.1 or
later.  Where does the manual say you cannot - we should fix that.


> 
> Can you tell me how properly to use crossmnt and nohide?

It is best not to use nohide - we should probably mark it as
'legacy'.

Simply export the top level mountpoint as 'crossmnt'  and everything
below there will be exported.

> Where should I put those options in root file-system export or in submount export?

crossmnt goes at the top.  nohide goes in the submount.  Both have
the same general effect though with subtle differences.
You don't need both (though that doesn't hurt).
Just use crossmnt at the top,  Then you don't need to mention the
lower level filesystems at all.

> 
> 2) NFS4 - I can't get it working:
> 
> *I have a LFS system, and this is what I did (NFS3 works fine, but crossmnt, and nohide seems not to work, probably due to above bug)
> 	I also have seen errors about stale handles 
> *Kernel - 2.6.24-rc3 with NFS3/4 client/server enabled on both host and guest. (both client and server running this kernel)
> *rpc.idmapd running on both client and server + all standard NFS3 tools
> *NFS tools 1.1.1 with nfs4 support compiled + without GSS (on server)
> * /etc/exports with fsid=0: (on server)
> 	/tmp *(fsid=0,insecure,rw,async,anonuid=100,anongid=1000)
> * mounting with -tnfs4 server:/ /mnt/tmp
> 
> Still doesn't work, using wireshark shows that
> 	NFSV4 COMPOUND call with
> 		Opcode: PUTROOTFH (24)
> 		Opcode: GETFH (10)
> 		Opcode: GETATTR (9)
> 
> Fails with 
> 	Reject State: AUTH_ERROR (1)
> 	Auth State: bad credential (seal broken) (1)
> 
> 
> Any ideas?
> 
> (I decided to switch to NFS4 only due to the lack of ability to see underlying mounts)
> 

All of this should work fine with v3.  Once you have the right patch
for the crossmnt bug applied, if you have further problems post them
to linux-nfs@vger.kernel.org.

NeilBrown
