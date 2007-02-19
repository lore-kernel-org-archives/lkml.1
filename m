Return-Path: <linux-kernel-owner+w=401wt.eu-S1750777AbXBSJTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750777AbXBSJTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 04:19:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbXBSJTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 04:19:03 -0500
Received: from smtp-out.google.com ([216.239.33.17]:7244 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbXBSJTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 04:19:01 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=eLGjRBxiR3Vk4xcGARfr2Ke99V6DV4MGu9kqHLA/PpNEJ5LgaU/Leet3N40eY3ose
	wBBM3+9Y/r8Wtj4quANbQ==
Message-ID: <6599ad830702190118r20b477d3q254c167c2fc2732@mail.gmail.com>
Date: Mon, 19 Feb 2007 01:18:55 -0800
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Balbir Singh" <balbir@in.ibm.com>
Subject: Re: [RFC][PATCH][1/4] RSS controller setup
Cc: linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, xemul@sw.ru, linux-mm@kvack.org,
       svaidy@linux.vnet.ibm.com, devel@openvz.org
In-Reply-To: <20070219005727.da2acdab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070219065019.3626.33947.sendpatchset@balbir-laptop>
	 <20070219065026.3626.36882.sendpatchset@balbir-laptop>
	 <20070219005727.da2acdab.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> This output is hard to parse and to extend.  I'd suggest either two
> separate files, or multi-line output:
>
> usage: %lu kB
> limit: %lu kB

Two separate files would be the container usage model that I
envisaged, inherited from the way cpusets does things.

And in this case, it should definitely be the limit in one file,
readable and writeable, and the usage in another, probably only
readable.

Having to read a file called memctlr_usage to find the current limit
sounds wrong.

Hmm, I don't appear to have documented this yet, but I think a good
naming scheme for container files is <subsystem>.<whatever> - i.e.
these should be memctlr.usage and memctlr.limit. The existing
grandfathered Cpusets names violate this, but I'm not sure there's a
lot we can do about that.

> > +static int memctlr_populate(struct container_subsys *ss,
> > +                             struct container *cont)
> > +{
> > +     int rc;
> > +     if ((rc = container_add_file(cont, &memctlr_usage)) < 0)
> > +             return rc;
> > +     if ((rc = container_add_file(cont, &memctlr_limit)) < 0)
>
> Clean up the first file here?

Containers don't currently provide an API for a subsystem to clean up
files from a directory - that's done automatically when the directory
is deleted.

I think I'll probably change the API for container_add_file to return
void, but mark an error in the container itself if something goes
wrong - that way rather than all the subsystems having to check for
error, container_populate_dir() can do so at the end of calling all
the subsystems' populate methods.

Paul
