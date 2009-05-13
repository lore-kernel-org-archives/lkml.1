Return-Path: <linux-kernel-owner+w=401wt.eu-S1759060AbZEMMaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060AbZEMMaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 08:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbZEMM34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 08:29:56 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:44812 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbZEMM34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 08:29:56 -0400
Subject: Re: [patch 00/13] devtmpfs patches
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jan Blunck <jblunck@suse.de>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, David Howells <dhowells@redhat.com>
In-Reply-To: <1242168913.6711.9.camel@poy>
References: <20090509143742.GA27663@kroah.com>
	 <1242063630.6624.22.camel@moss-terrapins.epoch.ncsc.mil>
	 <20090511175626.GA4758@kroah.com>
	 <1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil>
	 <ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com>
	 <1242132344.31807.48.camel@localhost.localdomain>
	 <ac3eb2510905120810n101dff08yfa945a2ab4b17168@mail.gmail.com>
	 <1242142528.31807.80.camel@localhost.localdomain>
	 <ac3eb2510905120854y7b44f608odf25af159fd6495c@mail.gmail.com>
	 <1242168913.6711.9.camel@poy>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 13 May 2009 08:22:22 -0400
Message-Id: <1242217342.9974.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 00:55 +0200, Kay Sievers wrote:
> On Tue, 2009-05-12 at 17:54 +0200, Kay Sievers wrote:
> > On Tue, May 12, 2009 at 17:35, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > 
> > > I think the issue is that the devtmpfs functions are calling vfs helpers
> > > to create and unlink the device nodes, and those helpers apply
> > > permission checks based on the current process' credentials.  I think a
> > > similar issue arose in sysfs a while ago.  Options are to either bypass
> > > the vfs helpers to avoid that permission checking for what I think are
> > > intended to be kernel-internal operations, or to override credentials
> > > temporarily around the calls to the vfs helpers, ala:
> > > new_cred = prepare_kernel_cred(NULL);
> > > old_cred  = override_creds(new_cred);
> > > rc = vfs_mknod(...);
> > > revert_creds(old_cred);
> > 
> > Ah, I see.
> 
> Here is the current state of the patch. It would be great, if you can
> have a quick look, if that matches what you meant. It runs fine here,
> but I didn't try any security enforcing software so far, which might run
> into trouble without the credential stuff.

I think you'll actually need to switch credentials around the entire
sequence starting from vfs_path_lookup() and going through the
vfs_mknod() call in order to avoid any denials from vfs_path_lookup,
vfs_mkdir (via create_path), and vfs_mknod.

Then the same issue applies to devtmpfs_delete_node() to prevent unlink
denials against the current process when a node is removed, similarly
wrapping everything from the vfs_path_lookup() through the final
delete_path() call.

-- 
Stephen Smalley
National Security Agency

