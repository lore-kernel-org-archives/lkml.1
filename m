Return-Path: <linux-kernel-owner+w=401wt.eu-S1763751AbXHCQH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763751AbXHCQH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 12:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762675AbXHCQHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 12:07:20 -0400
Received: from mail.fieldses.org ([66.93.2.214]:47883 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762639AbXHCQHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 12:07:19 -0400
Date: Fri, 3 Aug 2007 12:07:09 -0400
To: Neil Brown <neilb@suse.de>
Cc: Jeff Layton <jlayton@redhat.com>,
       Stefan Walter <stefan.walter@inf.ethz.ch>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [NFS] rpc.mountd crashes when extensively using netgroups
Message-ID: <20070803160709.GD456@fieldses.org>
References: <46ADDFB2.9070709@inf.ethz.ch> <20070731144824.GA15231@fieldses.org> <20070802113255.d686894c.jlayton@redhat.com> <18098.39541.547557.132952@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18098.39541.547557.132952@notabene.brown>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 01:01:09PM +1000, Neil Brown wrote:
> The core issue is this:
> 
>  We need to map IPADDRESS to THING, and  THING + PATH to EXPORTPOINT.
> (roughly).
> So what do we choose for "THING"?
> 
> One obvious option is the dotted quad of the IP address.
> People tend to have large sets of similar clients, so doing this seems
> to be missing out on a valuable optimisation and adding bloat to the
> lookup tables in the kernel.

$ gdb vmlinux
GNU gdb 6.6-debian
...
(gdb) print sizeof(struct ip_map)
$1 = 40
(gdb) print sizeof(struct svc_export)
$2 = 136

Hm, OK, one-address-per-export loses.

> I guess we could use a hash and keep a hash table in mountd.
> So mountd:
>   1/ Generates the comma-separated name as needed, being careful to
>      allocate enough space.
>   2a/ If this is small enough, write it to the kernel as is.
>   2b/ If it is too big, Find it in a table (adding if needed) and 
>       write the address of the table entry to the kernel
> 
>   When a THING + PATH request arrives:
>     If THING looks like an address in the table, do the lookup to get
>     the string.
> 
> This would work to keep the strings in the kernel shorter, but is
> rather ugly - storing in the kernel addresses in a user-space program.

If you use an actual collision-free hash function then the result will
be reproduceable, so you don't have to depend on temporary information
in mountd.

> So maybe we want to combine the two workable approaches.
> 
> Sometimes IPADDRESS maps to DOTTED_QUAD
> Sometimes IPADDRESS maps to LIST,OF,STRINGS,FROM,ETC,EXPORTS
> 
> Possibly the choice could be based on a command line switch.
> In the absence of such a switch, it could be based on the number of
> entries in /etc/exports.

Seems OK.

--b.
