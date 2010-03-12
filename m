Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0CLBYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 20:24:20 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:63620 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab0CLBYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 20:24:19 -0500
X-Authority-Analysis: v=1.0 c=1 a=hRh-p0rce0wA:10 a=kj9zAlcOel0A:10 a=hGzw-44bAAAA:8 a=Lm5c0-V0AAAA:8 a=RWIe-DdVPRBF6tCeT-AA:9 a=MTskM_aZ7mMntVklJ-8A:7 a=kZpSbiUADmQf5EnKmN5OSP-4ZyIA:4 a=CjuIK1q_8ugA:10 a=dowx1zmaLagA:10 a=0e_BQ5Ttg00A:10
X-Cloudmark-Score: 0
X-Originating-IP: 71.70.153.3
Date: Thu, 11 Mar 2010 20:24:18 -0500
From: Jeff Layton <jlayton@samba.org>
To: Michael Adam <obnox@samba.org>
Cc: Jon Severinsson <jon@severinsson.net>, linux-cifs-client@lists.samba.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       vl@samba.org
Subject: Re: [linux-cifs-client] [RFC PATCH] CIFS posix acl permission
 checking
Message-ID: <20100311202418.57486bd0@tupile.poochiereds.net>
In-Reply-To: <E1Npr8D-00A474-O0@intern.SerNet.DE>
References: <201003041150.08341.jon@severinsson.net>
	<20100304111812.6af53003@barsoom.rdu.redhat.com>
	<E1Npr8D-00A474-O0@intern.SerNet.DE>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010 23:45:29 +0100
Michael Adam <obnox@samba.org> wrote:

> Jeff Layton wrote:
> > On Thu, 4 Mar 2010 11:50:04 +0100
> > Jon Severinsson <jon@severinsson.net> wrote:
> > 
> > > Hello
> > > 
> > > Early this weak I sent a patch implementing posix acl permission checking in 
> > > the linux cifs filesystem module. Unfortunately I only sent it to linux-fsdev 
> > > as I was unaware of the linux-cifs-client list. I later tried to submit it to 
> > > linux-cifs-client as well, but my message seems to have been lost in the 
> > > moderation queue, so I subscribed and am trying again.
> > >
> > > ...
> > 
> > (cc'ing Michael Adam since he's been working on a similar patch)
> > 
> > I've looked over the patch and it's pretty good for a first attempt.
> > There are a few minor problems with it, but it's a reasonable first
> > pass.
> > 
> > The issues I have are with the approach -- you've stepped into a bit of
> > a minefield with regards to CIFS' design. The issues that Simo brings up
> > however are quite valid. Let me just state outright that permission
> > checking on the client is a completely bogus concept. There are a
> > couple of problems with this approach:
> > 
> > 1) Someone could change the permissions on the server between the time
> > you check them and when you do your operation. Yes, I know that CIFS
> > already does this for permission bits, but that's dumb too.
> > 
> > 2) Ownership matters. This patch will have no effect on how files get
> > created. They still get created with the owner set to the user who's
> > credentials were used, and you can't change them afterward (since users
> > can't "chown" files to other users). Now, it is possible to mount a
> > samba server with root's credentials. Then you can use the "setuids"
> > mount option to make chown's work and you *might* get files created the
> > way you intend. I really, really do not recommend this though -- it's a
> > bad idea to allow any user to share root's server credentials.
> 
> I completely agree that client side checking is bogus.
> And as already mentioned in a different mail, the "setuids"
> option seems to be broken currently (in my test cases at least).
> 

Ok, some investigation as to the cause there might be helpful. That
said, the whole idea of mounting using root's creds seems a bit
dangerous to me. I can't point to a specific attack vector that employs
mounting with root creds, but it "smells" like bad practice.

> > I'm convinced, after working on it for more than 3 years that the *only*
> > proper fix for the nightmare that is CIFS permissions is to make CIFS
> > use proper credentials in the first place. CIFS is currently completely
> > broken in this regard -- it's designed such that all accesses to the
> > mount use the same set of credentials, and that's just plain wrong.
> > 
> > Fixing this entails establishing new SMB sessions on the fly whenever a
> > user wants to do an on the wire operation. Obviously, we can't prompt
> > for passwords for this, so we need to limit this to krb5 creds or come
> > up with a way for people to stash credentials for the kernel to use for
> > this purpose.
> 
> So this method of "stashing" creds would usually involve some
> kind of upcall to e.g. query the winbindd credential cache or
> some static text file, right?
> 

Actually, I was more envisioning using the kernel keyring to stash a
username, and password or NTLM hash. The kernel can then scoop those up
as needed without needing to upcall. You could do this per-user or
per-session too. Eventually we want to overhaul the krb5 code to do
less in userspace too.

See the keyctl_* manpages for details on that facility.

> When discussing this with Volker today, he had a different idea:
> One could implement a trans2 impersonate call in samba (as a new
> call in the unix extensions) that could be used to transfer the
> session established by the privileged user (root, say) to a
> different user specified as an argument to the call -- without
> the need to give credentials! Then this call could be used in
> the multi user mount scenario: when uid 1000 accesse the cifs
> mount then the root-dispatcher mount would create a new session
> initially as root and issue an impersonate call to user 1000
> directly afterwards.
> 
> Wouldn't that be something worth considering?
> 

I've only just read this, and haven't thought about it fully, but at
first glance that looks like the wrong way to go about fixing this. For
one thing, this is a samba only extension. For another, you're still
allowing "credential sharing" to some degree and that scheme encourages
people to mount using root's credentials.

The bottom line (IMO) is that any scheme that has multiple users
sharing credentials on a single SMB session is just a bad solution.
Credentials exist for a reason and really shouldn't be shared.

> > I'm about 1/3 of the way into a first draft of a patchset
> > to do this, but it won't be fixed anytime soon and may not be suitable
> > for CIFS with SMB2 getting development focus now.
> 
> Sorry, what do you mean? Is SMB2 somehow contradictory to multi
> session mounts?
> 

No, but the SMB2 code is a completely separate project however. What
there is of it today consists largely of code and functionality that is
cut-and-pasted from CIFS. Any fixes that gets implemented in CIFS
will need to be essentially duplicated for SMB2.

-- 
Jeff Layton <jlayton@samba.org>
