Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbXHCDBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbXHCDBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 23:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbXHCDB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 23:01:29 -0400
Received: from ns1.suse.de ([195.135.220.2]:42215 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbXHCDB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 23:01:28 -0400
From: Neil Brown <neilb@suse.de>
To: Jeff Layton <jlayton@redhat.com>
Date: Fri, 3 Aug 2007 13:01:09 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18098.39541.547557.132952@notabene.brown>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Stefan Walter <stefan.walter@inf.ethz.ch>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [NFS] rpc.mountd crashes when extensively using netgroups
In-Reply-To: message from Jeff Layton on Thursday August 2
References: <46ADDFB2.9070709@inf.ethz.ch>
	<20070731144824.GA15231@fieldses.org>
	<20070802113255.d686894c.jlayton@redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday August 2, jlayton@redhat.com wrote:
> 
> I started having a look at this today. The original patches that I
> proposed to clean up the rmtab a few months ago also eliminated this
> comma-delimited string. Neil had valid objections to it at the time,
> but if we switched to using the IP address as a cache key like Bruce
> describes then doing that becomes more reasonable.
> 
> The only downside I see is the one Bruce points out -- the size of
> the kernel export cache would increase. I don't have a feel for whether
> this is a show stopper, however.
> 
> Neil, do you have thoughts on what you'd consider a reasonable approach
> to fixing this?
> 

I'm having troubling visualising the problematic setup.  Is it
possible to get a copy of the /etc/exports file, and some idea of what
hosts are in which netgroups?  Knowing that would help assess the
appropriateness of various solutions.


The core issue is this:

 We need to map IPADDRESS to THING, and  THING + PATH to EXPORTPOINT.
(roughly).
So what do we choose for "THING"?

One obvious option is the dotted quad of the IP address.
People tend to have large sets of similar clients, so doing this seems
to be missing out on a valuable optimisation and adding bloat to the
lookup tables in the kernel.

Another apparently obvious solution is to use FQDN, but we really
don't want to do that, as a multihomed host might have one IP address
that you want to trust, and another that you don't (as the subnet is
less secure against forgery).  It doesn't help must over dotted-quad
anyway.

Another option is to use whatever strings are included in /etc/exports
to identify things.  e.g. *.my.domain or @mynetgroup.
This seems simple and elegant, but it can be messy in some
situations.  In particular, if one IP address matches several strings,
which one do you use?  We have to use them all.
One path might be exported to *.my.domain and a different path might
be exported to @mynetgroup.  If a.b.c.d is in both of those sets of
machines, then the THING that a.b.c.d is mapped to must allow the
correct
    THING + PATH -> EXPORTPOINT
mapping for both paths.
    *.my.domain,@mynetgroup
works quite effectively.
But if you have lots and lots of different netgroups mentioned in
/etc/exports, and one machine is in all of those netgroups, then you
have to generate a very long string @a,@b,@c,@d,.....

I guess we could use a hash and keep a hash table in mountd.
So mountd:
  1/ Generates the comma-separated name as needed, being careful to
     allocate enough space.
  2a/ If this is small enough, write it to the kernel as is.
  2b/ If it is too big, Find it in a table (adding if needed) and 
      write the address of the table entry to the kernel

  When a THING + PATH request arrives:
    If THING looks like an address in the table, do the lookup to get
    the string.

This would work to keep the strings in the kernel shorter, but is
rather ugly - storing in the kernel addresses in a user-space program.

Also, if you have lots of netgroups mentioned, then finding out which
ones contain a given IP address might be slow, and all the information
isn't really needed.  Once you get THING, it will be paired with a
specific path, so you only really need to look up netgroups that are
related to that path.

So maybe we want to combine the two workable approaches.

Sometimes IPADDRESS maps to DOTTED_QUAD
Sometimes IPADDRESS maps to LIST,OF,STRINGS,FROM,ETC,EXPORTS

Possibly the choice could be based on a command line switch.
In the absence of such a switch, it could be based on the number of
entries in /etc/exports.

	int i;
	int size = 0;
	nfs_client	*clp;

	for (i = 0 ; i < MCL_MAXTYPES; i++)
		for (clp = clientlist[i]; clp ; clp = clp->m_next)
			size += strlen(clp->m_hostname)+1;

	if (size > 1000)
		use DOTTED_QUAD;
	els
		don't.


??

NeilBrown
