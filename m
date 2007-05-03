Return-Path: <linux-kernel-owner+w=401wt.eu-S637746AbXECPfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637746AbXECPfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637753AbXECPfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:35:44 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:63614 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S637746AbXECPfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:35:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qcOAhx1ggHRW2BnXanV0WivNoseu2kUOKPN1H2Vpr8sL1Jam05Wc+BqPco+qMh4FqUGkPtJN8Drk4A+lFXBnuv8Pbk/UxJ5mlkuc1PIpasFWtWlEXsK5Du3wkJULfUJ+vf0TG78cMKOPom9w1+DgZV7GVwNMii/jb3B/rc/D5NQ=
Message-ID: <524f69650705030835y488b0493wc97ab79ba25cd539@mail.gmail.com>
Date: Thu, 3 May 2007 10:35:41 -0500
From: "Steve French" <smfrench@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [linux-cifs-client] Re: SMB2 file system - should it be a distinct module
Cc: "Gerald Carter" <coffeedude.jerry@gmail.com>,
       "Christoph Hellwig" <hch@infradead.org>,
       linux-cifs-client@lists.samba.org, simo <idra@samba.org>
In-Reply-To: <1178204186.28758.37.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com>
	 <20070501090657.GA17949@infradead.org>
	 <1178198489.28758.14.camel@localhost.localdomain>
	 <20070503141742.GB20328@infradead.org>
	 <1178203013.28758.29.camel@localhost.localdomain>
	 <4639F5AD.20807@gmail.com>
	 <1178204186.28758.37.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To clarify:

1) SMB2 is negotiated like a new dialect (of SMB/CIFS).  The new
dialects is sent in the same SMB negotiate protocol request that has
been used for years.  The protocol header format changes to that of
SMB2 (if accepted by the server) on all subsequent requests.
2) If the server does not support SMB2, the client should fall back to
using CIFS (as existing SMB2 clients do).
3) So far, all servers which support SMB2 also support CIFS.

If SMB2 protocol support were coded as a distinct module, the smb2.ko
would need to load cifs.ko to complete session setup in many cases
(presumably when mounting to NetApp, EMC, most older Windows servers
and some Samba servers - at least for a few years).

Because we (Samba, Linux client and even MacOS, HP/UX) have added
optional extensions to CIFS which are not present in SMB2 (although we
should add them), the difficulty is simply which to try first:
1) If we knew the server did not support the CIFS Unix Exensions (CIFS
POSIX Protocol Extensions) but the server was new enough to support
SMB2 then we should request SMB2 (as soon as a stable SMB2 Linux
kernel client were written/tested).   SMB2 has increased limits on
file handles, and should perform marginally better (if the client were
well implemented, unlike some non-Linux clients ...)

But we don't know until the response from the SMB Negotiate Protocol
what the server capabilities are.

Eventually this problem goes away, when we specify and code Unix
Protocol Extensions to SMB2 for Samba etc. as we have done for CIFS,
but in the meantime, I am leaning toward:

1) trying SMB/CIFS only (not including SMB2 dialect) on DFS referrals
by default (unless the user configures the client differently at run
time)
2) On mount trying smb2 only if the user mounted explicitly with "-t
smb2" (but fallback to CIFS if the server does not support SMB2) -
otherwise (for "-t cifs") mount is unchanged.

In any case SMB2 would be considered experimental (for a Linux client)
for quite some time, so there is no hurry to decide until there is
feedback from users.  I am pleased that SMB2 does clean up the
protocol header format - and it should be easier to code in some ways
since there are so few operations to support/optimize (and almost all
are handlebased), but it is way to early to tell which is better (as
far as I know, no one has even proved whether SMB2 is faster than CIFS
or Vista to Vista mounts).

On 5/3/07, simo <idra@samba.org> wrote:
> On Thu, 2007-05-03 at 09:46 -0500, Gerald Carter wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> >
> > Simo,
> >
> > > I guess DFS referrals can work cross protocol, so if you are redirected
> > > from a longhorn server to a windoes 2000 or a samba server you want to
> > > be able to follow the DFS referral and not return an error.
> > > To do that you need to have either 1 module that support both protocols
> > > or a way from one module to call the other. Just separating the 2
> > > without any glue will not work (or you will have to add some userspace
> > > upcall hack to make it work).
> >
> > Long term I agree that CIFS and SMB2 should be in the same .ko
> > But NTLM 0.12 still works for Vista and DFS referrals.
> > Breaking out SMB2 initially means that it will not clutter
> > the working cifs.ko code.  Remember that an SMB2 client fs is
> > mostly research at this point, and not engineering.
>
> Well, development can happen in any way Steve or any other like to do
> it, but it seemed to me that the proposal was to split them long term.
>
> I think this would be bad wrt supporting DFS referrals.
>
> That said, it I'll shut up as kindly requested from someone that seem to
> know better than Samba/CIFS developers.
>
> Simo.
>
> --
> Simo Sorce
> Samba Team GPL Compliance Officer
> email: idra@samba.org
> http://samba.org
>
>


-- 
Thanks,

Steve
