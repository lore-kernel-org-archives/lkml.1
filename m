Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbZBESoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbZBESoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbZBESn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:43:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35705 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789AbZBESn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:43:56 -0500
Date: Thu, 5 Feb 2009 13:43:04 -0500
From: Jason Baron <jbaron@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, gnb@sgi.com, gregkh@suse.de,
       nfsv4@linux-nfs.org, systemtap@sources.redhat.com
Subject: Re: [Patch 0/2] dynamic debug
Message-ID: <20090205184304.GF3114@redhat.com>
References: <20090205164520.GB3114@redhat.com> <20090205175849.GA936@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205175849.GA936@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 09:58:49AM -0800, Greg KH wrote:
> On Thu, Feb 05, 2009 at 11:45:20AM -0500, Jason Baron wrote:
> > hi,
> > 
> > This patchset combines Greg Bank's dprintk() patchset with the dynamic printk
> > patchset. We are renaming the combined solution 'dynamic debug'. As a reminder,
> > the patchset allows debug printk style statements to be dynamically 
> > enabled/disabled at runtime.
> > 
> > The key new feature of this patchset is a richer /debugfs control file
> > interface, (an example output from my system is at the bottom), which allows
> > fined grained control over the the debug output. The output can be controlled by
> > function, file and line number, module, and format string. 
> 
> That's nice, but do we really need to have that kind of control?  It
> seems like overkill.
> 

given the ability of this feature to very quickly fill the logs, I think
it makes sense for some cases. Also, Greg found it very useful in his debugging
work...

> > For example, to enable all debug statement in module 'nf_conntrack':
> > 
> > #echo -n 'module nf_conntrack +p' > /mnt/debugfs/dynamic_debug/control
> > 
> > A further explanation can be found in the documentation patch.
> > 
> > While adding these new features we have dropped a couple that we intend to add
> > back in subsequent patches. The ability to turn on/off all debugging at once,
> > either via the /debugfs control file, or via the kernel command line.
> > 
> > thanks,
> > 
> > -Jason and Greg
> > 
> > 
> > # filename:lineno [module]function flags format
> > arch/x86/kernel/setup_percpu.c:260 [setup_percpu]numa_set_node - "Setting\040node\040for\040non-present\040cpu\040%d\012"
> 
> Why the \040 syntax?  Can't we handle a space in a string?  Makes it
> very hard to grep for things...
> 

ok, patch below resolves the space issue.

thanks,

-Jason

Signed-off-by: Jason Baron <jbaron@redhat.com>

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 7db55ce..9e123ae 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -572,7 +572,7 @@ static int ddebug_proc_show(struct seq_file *m, void *p)
 		   dp->filename, dp->lineno,
 		   iter->table->mod_name, dp->function,
 		   ddebug_describe_flags(dp, flagsbuf, sizeof(flagsbuf)));
-	seq_escape(m, dp->format, " \t\r\n\"");
+	seq_escape(m, dp->format, "\t\r\n\"");
 	seq_puts(m, "\"\n");
 
 	return 0;


