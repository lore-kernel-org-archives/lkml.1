Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbXH0SLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbXH0SLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 14:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757814AbXH0SK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 14:10:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57115 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751049AbXH0SK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 14:10:58 -0400
Date: Mon, 27 Aug 2007 13:10:56 -0500
From: Dean Nelson <dcn@sgi.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: akpm@linux-foundation.org, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, tony.luck@intel.com,
       jes@sgi.com
Subject: Re: [PATCH 1/4] export __put_task_struct for XPMEM
Message-ID: <20070827181056.GA30176@sgi.com>
References: <20070827155622.GA25589@sgi.com> <20070827155933.GB25589@sgi.com> <20070827161327.GG21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827161327.GG21089@ftp.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 05:13:28PM +0100, Al Viro wrote:
> On Mon, Aug 27, 2007 at 10:59:33AM -0500, Dean Nelson wrote:
> > This patch exports __put_task_struct as it is needed by XPMEM.
> > 
> > Signed-off-by: Dean Nelson <dcn@sgi.com>
> > 
> > ---
> > 
> > One struct file_operations registered by XPMEM, xpmem_open(), calls
> > 'get_task_struct(current->group_leader)' and another, xpmem_flush(), calls
> > 'put_task_struct(tg->group_leader)'.
> 
> Does it?  Well, then open the file in question and start doing close(dup(fd))
> in a loop.  Won't take long for an oops...

Actually it won't oops. And that's because when the file is opened,
xpmem_open() creates a structure for that thread group, and when
xpmem_flush() is called on the close() it first looks for that structure
and if it finds it then it does what it needs to do (which includes the
put_task_struct() call) and then finishes off by destroying the structure.
So for subsequent closes xpmem_flush() returns without calling
put_task_struct().
