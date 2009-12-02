Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbZLBTOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbZLBTOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 14:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZLBTOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 14:14:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbZLBTOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 14:14:53 -0500
Date: Wed, 2 Dec 2009 14:12:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com
Subject: Re: Block IO Controller V4
Message-ID: <20091202191253.GH31715@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com> <4e5e476b0911300734h34a22c88oa5d7d4e5642ead50@mail.gmail.com> <20091130160024.GD11670@redhat.com> <4e5e476b0911301334o2440ea8fi7444aa7d5a688ed1@mail.gmail.com> <1259618433.2701.31.camel@cail> <20091130225640.GO11670@redhat.com> <1259625025.2701.33.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259625025.2701.33.camel@cail>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 06:50:25PM -0500, Alan D. Brunelle wrote:
> On Mon, 2009-11-30 at 17:56 -0500, Vivek Goyal wrote:
> > On Mon, Nov 30, 2009 at 05:00:33PM -0500, Alan D. Brunelle wrote:
> > > FYI: Results today from my test suite - haven't had time to parse them
> > > in any depth...
> > 
> > Thanks Alan. I am trying to parse the results below. s0 and s8 still mean
> > slice idle enabled disabled? Instead of that we can try group_isolation
> > enabled or disabled for all the tests.
> 
> I'm concerned as well - I think I did the base run /after/ the i1,s0
> run. I'll need to check that out tomorrow...
> 

Hi Alan, Gui,

Currently fio does not have support for putting jobs in appropriate
cgroups. Hence I wrote the scripts to move jobs in to right cgroup. But
this had the issue of synchronization between threads so that they all
start at same time after laying out the files. I had written some programs
to synchronize on external semaphore. This was getting complicated.

Now I have written this small hacky patch to modify fio to launch a job
in specified cgroup. Just use following in your job file or command line.

cgroup=<cgroup dir path>

In my initial testing it seems to be working both from command line and
from job file. I will test it more. Sending the patch in this thread because
you and Gui seems to be testing this stuff and life will become little easier.

Thanks
Vivek


o A simple patch to put run a fio job in a specific cgroup. Its a simple hack
  and not much of error checking. So make sure cgroup exists.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 HOWTO     |    3 +++
 fio.c     |    8 ++++++++
 fio.h     |    1 +
 options.c |    7 +++++++
 4 files changed, 19 insertions(+)

Index: fio/options.c
===================================================================
--- fio.orig/options.c	2009-12-02 11:10:36.000000000 -0500
+++ fio/options.c	2009-12-02 13:40:49.000000000 -0500
@@ -1727,6 +1727,13 @@ static struct fio_option options[] = {
 		.help	= "Select a specific builtin performance test",
 	},
 	{
+		.name	= "cgroup",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= td_var_offset(cgroup),
+		.cb	= str_directory_cb,
+		.help	= "cgroup directory to run the job in",
+	},
+	{
 		.name = NULL,
 	},
 };
Index: fio/fio.h
===================================================================
--- fio.orig/fio.h	2009-12-02 11:10:36.000000000 -0500
+++ fio/fio.h	2009-12-02 13:42:26.000000000 -0500
@@ -271,6 +271,7 @@ struct thread_options {
 	 * Benchmark profile type
 	 */
 	unsigned int profile;
+	char *cgroup;
 };
 
 #define FIO_VERROR_SIZE	128
Index: fio/fio.c
===================================================================
--- fio.orig/fio.c	2009-12-02 11:10:36.000000000 -0500
+++ fio/fio.c	2009-12-02 13:51:16.000000000 -0500
@@ -1025,6 +1025,14 @@ static void *thread_main(void *data)
 	pthread_cond_init(&td->verify_cond, &attr);
 	pthread_cond_init(&td->free_cond, &attr);
 
+	/* Move thread to right cgroup */
+	if (td->o.cgroup) {
+		char str[50];
+		sprintf(str, "echo %d > %s/tasks", td->pid, td->o.cgroup);
+		if (system(str) == -1)
+			log_err("fio: exec of cmd <%s> failed\n", str);
+	}
+
 	td_set_runstate(td, TD_INITIALIZED);
 	dprint(FD_MUTEX, "up startup_mutex\n");
 	fio_mutex_up(startup_mutex);
Index: fio/HOWTO
===================================================================
--- fio.orig/HOWTO	2009-12-02 11:10:36.000000000 -0500
+++ fio/HOWTO	2009-12-02 14:04:55.000000000 -0500
@@ -1003,6 +1003,9 @@ continue_on_error=bool	Normally fio will
 		given in the stats is the first error that was hit during the
 		run.
 
+cgroup=str	Specify the cgroup directory in which a job should run.
+		ex. cgroup=/cgroup/blkio/test1/
+
 
 6.0 Interpreting the output
 ---------------------------
