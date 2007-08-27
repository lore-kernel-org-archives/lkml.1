Return-Path: <linux-kernel-owner+w=401wt.eu-S1760901AbXH0TTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901AbXH0TTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 15:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbXH0TTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 15:19:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33235 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756631AbXH0TTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 15:19:08 -0400
Date: Mon, 27 Aug 2007 14:19:06 -0500
From: Dean Nelson <dcn@sgi.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: akpm@linux-foundation.org, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, tony.luck@intel.com,
       jes@sgi.com
Subject: Re: [PATCH 1/4] export __put_task_struct for XPMEM
Message-ID: <20070827191906.GB30176@sgi.com>
References: <20070827155622.GA25589@sgi.com> <20070827155933.GB25589@sgi.com> <20070827161327.GG21089@ftp.linux.org.uk> <20070827181056.GA30176@sgi.com> <20070827181544.GH21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827181544.GH21089@ftp.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 07:15:44PM +0100, Al Viro wrote:
> On Mon, Aug 27, 2007 at 01:10:56PM -0500, Dean Nelson wrote:
> > On Mon, Aug 27, 2007 at 05:13:28PM +0100, Al Viro wrote:
> > > On Mon, Aug 27, 2007 at 10:59:33AM -0500, Dean Nelson wrote:
> > > > This patch exports __put_task_struct as it is needed by XPMEM.
> > > > 
> > > > Signed-off-by: Dean Nelson <dcn@sgi.com>
> > > > 
> > > > ---
> > > > 
> > > > One struct file_operations registered by XPMEM, xpmem_open(), calls
> > > > 'get_task_struct(current->group_leader)' and another, xpmem_flush(), calls
> > > > 'put_task_struct(tg->group_leader)'.
> > > 
> > > Does it?  Well, then open the file in question and start doing close(dup(fd))
> > > in a loop.  Won't take long for an oops...
> > 
> > Actually it won't oops. And that's because when the file is opened,
> > xpmem_open() creates a structure for that thread group, and when
> > xpmem_flush() is called on the close() it first looks for that structure
> > and if it finds it then it does what it needs to do (which includes the
> > put_task_struct() call) and then finishes off by destroying the structure.
> > So for subsequent closes xpmem_flush() returns without calling
> > put_task_struct().
> 
> Then what kind of protection does it get you?  It can be called immediately
> after the call of ->open(), so you can't rely on it being there for any
> operations.  Makes no sense...

No operations can be done once it's closed, only while it's opened.

At fault time we need to be able to fault pages that belong to another
thread group. To call get_user_pages() we need to have the task_struct
and the mm_struct for the other thread group.

At one time we did look up the task_struct by pid, but that brought the
system to its knees due to heavy lock contention.

Do you know of a better way of doing this?
