Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbZEMNFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbZEMNFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbZEMNFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:05:19 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:35436 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZEMNFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:05:17 -0400
Subject: Re: [patch 00/13] devtmpfs patches
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jan Blunck <jblunck@suse.de>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, David Howells <dhowells@redhat.com>
In-Reply-To: <ac3eb2510905130558s493d8c9m667348d183c97721@mail.gmail.com>
References: <20090509143742.GA27663@kroah.com>
	 <20090511175626.GA4758@kroah.com>
	 <1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil>
	 <ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com>
	 <1242132344.31807.48.camel@localhost.localdomain>
	 <ac3eb2510905120810n101dff08yfa945a2ab4b17168@mail.gmail.com>
	 <1242142528.31807.80.camel@localhost.localdomain>
	 <ac3eb2510905120854y7b44f608odf25af159fd6495c@mail.gmail.com>
	 <1242168913.6711.9.camel@poy>
	 <1242217342.9974.10.camel@localhost.localdomain>
	 <ac3eb2510905130558s493d8c9m667348d183c97721@mail.gmail.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 13 May 2009 08:57:51 -0400
Message-Id: <1242219471.9974.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 14:58 +0200, Kay Sievers wrote:
> On Wed, May 13, 2009 at 14:22, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > I think you'll actually need to switch credentials around the entire
> > sequence starting from vfs_path_lookup() and going through the
> > vfs_mknod() call in order to avoid any denials from vfs_path_lookup,
> > vfs_mkdir (via create_path), and vfs_mknod.
> >
> > Then the same issue applies to devtmpfs_delete_node() to prevent unlink
> > denials against the current process when a node is removed, similarly
> > wrapping everything from the vfs_path_lookup() through the final
> > delete_path() call.
> 
> Ok, good, will do that. Anything like this to keep in mind when
> creating/removing simple subdirectories?

Yes, any time you call any vfs helper (and thus are subject to the
permission checking calls, both DAC and LSM/SELinux), you need to decide
whether you truly want those permission checks to get applied against
the current process' credentials or whether you should be using
alternate credentials for the call.  If on the other hand you can
perform your operations at a lower level (e.g. direct calls to the
underlying inode operations), then you don't have to be concerned with
the permission checking, but there is still the issue of ownership and
file security labeling for any new files/directories you create, so even
there you may need to establish different credentials to avoid
unwittingly creating those files with the uid/security context of
whatever the current process happens to be.

-- 
Stephen Smalley
National Security Agency

