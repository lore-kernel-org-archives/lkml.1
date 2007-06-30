Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbXF3JNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbXF3JNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 05:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbXF3JNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 05:13:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60608 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbXF3JND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 05:13:03 -0400
Date: Sat, 30 Jun 2007 10:13:02 +0100
From: Christoph Hellwig <hch@infradead.org>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [RFD 1/4] Pass no useless nameidata to the create, lookup, and permission IOPs
Message-ID: <20070630091302.GA21784@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, jjohansen@suse.de,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>
References: <20070626231510.883881222@suse.de> <20070626231541.697783295@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626231541.697783295@suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 04:15:11PM -0700, jjohansen@suse.de wrote:
> The create, lookup, and permission inode operations are all passed a
> full nameidata.  This is unfortunate because in nfsd and the mqueue
> filesystem, we must instantiate a struct nameidata but cannot provide
> all of the same information that a regular lookup would provide.  The
> unused fields take up space on the stack, but more importantly, it is
> not obvious which fields have meaningful values and which don't, and so
> things might easily break.
> 
> This patch introduces struct nameidata2 with only the fields that make
> sense independent of an actual lookup, and uses that struct in those
> places where a full nameidat is not needed.

We need something like this, but I don't quite like the way you've done
it.  First the name is wrong, it's not a nameidata anymore but a lookup
intent, so it should be named that way, struct lookup_intent.  Second
the macro hackery is more than ugly,  please keep the structures separate.
With modern gcc it might be possible to embed the lookup_intent into
the nameidata anonymously.  Also please either remove the dentry from
struct lookup_entry or from the direct argument list of the functions
and methods - there is no need to pass this one twice.

