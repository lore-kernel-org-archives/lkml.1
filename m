Return-Path: <linux-kernel-owner+w=401wt.eu-S932694AbZEAPBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbZEAPBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 11:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764541AbZEAO4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:56:46 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53812 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765380AbZEAO4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:56:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kP6jpuL1aSePxLrrKrK2sKK6OoMs3ktWngLiC0R8GMEHXaBU/ttg4DRNH8Q8fD/DHI
         ZdGlsemtqVBZ2uAxDhxH94f+Xnp1ncR59ipEqlyJ2Da8zJHX2Ro8eT96SD8aPuwIt7Qg
         Vu1Hq2TtGeSiRZfRUvwNcUKvlxc0QDvMQFEms=
Date: Fri, 1 May 2009 16:56:40 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: peterz@infradead.org, rientjes@google.com, david@fromorbit.com,
       cl@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: prevent divide error for small values of
	vm_dirty_bytes
Message-ID: <20090501145639.GA24443@linux>
References: <1240993759-30787-1-git-send-email-righi.andrea@gmail.com> <1240994676.8021.83.camel@laptop> <20090429093449.GB3151@linux> <20090429144655.e60fdf7a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429144655.e60fdf7a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 02:46:55PM -0700, Andrew Morton wrote:
> On Wed, 29 Apr 2009 11:34:51 +0200
> Andrea Righi <righi.andrea@gmail.com> wrote:
> 
> > --- a/Documentation/sysctl/vm.txt
> > +++ b/Documentation/sysctl/vm.txt
> > @@ -90,6 +90,10 @@ will itself start writeback.
> >  If dirty_bytes is written, dirty_ratio becomes a function of its value
> >  (dirty_bytes / the amount of dirtyable system memory).
> >  
> > +Note: the minimum value allowed for dirty_bytes is two pages (in bytes); any
> > +value lower than this limit will be ignored and the old configuration will be
> > +retained.
> 
> Well.  This implies that the write to the procfs file would appear to
> succeed.  One hopes that the write would in fact return -EINVAL or
> such?

I definitely agree. Just tested the following patch and it looks much
better with the error code.

-Andrea

---
sysctl: return error code if values are not within a valid range

Currently __do_proc_doulongvec_minmax(), as well as
__do_proc_dointvec(), simply skip the invalid values instead of return
-EINVAL.

A more correct behaviour is to report to the userspace that some values
were invalid and they couldn't be written instead of silently drop
them.

For example (vm_dirty_bytes must be greater or equal than 2*PAGE_SIZE):
- before:
  # cat /proc/sys/vm/dirty_bytes
  0
  # /bin/echo 1 > /proc/sys/vm/dirty_bytes
  # cat /proc/sys/vm/dirty_bytes
  0
  # /bin/echo 8192 > /proc/sys/vm/dirty_bytes
  # cat /proc/sys/vm/dirty_bytes
  8192

- after:
  # cat /proc/sys/vm/dirty_bytes
  0
  # /bin/echo 1 > /proc/sys/vm/dirty_bytes
  /bin/echo: write error: Invalid argument
  # cat /proc/sys/vm/dirty_bytes
  0
  # /bin/echo 8192 > /proc/sys/vm/dirty_bytes
  # cat /proc/sys/vm/dirty_bytes
  8192

As a bonus do few minor coding style fixup.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 kernel/sysctl.c |   47 +++++++++++++++++++++++++++++++----------------
 1 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ea78fa1..92e56cf 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2243,19 +2243,19 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 		  void *data)
 {
 #define TMPBUFLEN 21
-	int *i, vleft, first=1, neg, val;
+	int *i, vleft, first = 1, neg, val, ret = 0;
 	unsigned long lval;
 	size_t left, len;
-	
+
 	char buf[TMPBUFLEN], *p;
 	char __user *s = buffer;
-	
+
 	if (!tbl_data || !table->maxlen || !*lenp ||
 	    (*ppos && !write)) {
 		*lenp = 0;
 		return 0;
 	}
-	
+
 	i = (int *) tbl_data;
 	vleft = table->maxlen / sizeof(*i);
 	left = *lenp;
@@ -2288,26 +2288,31 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 				neg = 1;
 				p++;
 			}
-			if (*p < '0' || *p > '9')
+			if (*p < '0' || *p > '9') {
+				ret = -EINVAL;
 				break;
+			}
 
 			lval = simple_strtoul(p, &p, 0);
 
 			len = p-buf;
-			if ((len < left) && *p && !isspace(*p))
+			if ((len < left) && *p && !isspace(*p)) {
+				ret = -EINVAL;
 				break;
+			}
 			if (neg)
 				val = -val;
 			s += len;
 			left -= len;
 
-			if (conv(&neg, &lval, i, 1, data))
+			ret = conv(&neg, &lval, i, 1, data);
+			if (ret)
 				break;
 		} else {
 			p = buf;
 			if (!first)
 				*p++ = '\t';
-	
+
 			if (conv(&neg, &lval, i, 0, data))
 				break;
 
@@ -2339,6 +2344,8 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 	}
 	if (write && first)
 		return -EINVAL;
+	if (write && ret)
+		return ret;
 	*lenp -= left;
 	*ppos += *lenp;
 	return 0;
@@ -2477,23 +2484,23 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 {
 #define TMPBUFLEN 21
 	unsigned long *i, *min, *max, val;
-	int vleft, first=1, neg;
+	int vleft, first = 1, neg, ret = 0;
 	size_t len, left;
 	char buf[TMPBUFLEN], *p;
 	char __user *s = buffer;
-	
+
 	if (!data || !table->maxlen || !*lenp ||
 	    (*ppos && !write)) {
 		*lenp = 0;
 		return 0;
 	}
-	
+
 	i = (unsigned long *) data;
 	min = (unsigned long *) table->extra1;
 	max = (unsigned long *) table->extra2;
 	vleft = table->maxlen / sizeof(unsigned long);
 	left = *lenp;
-	
+
 	for (; left && vleft--; i++, min++, max++, first=0) {
 		if (write) {
 			while (left) {
@@ -2519,12 +2526,16 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 				neg = 1;
 				p++;
 			}
-			if (*p < '0' || *p > '9')
+			if (*p < '0' || *p > '9') {
+				ret = -EINVAL;
 				break;
+			}
 			val = simple_strtoul(p, &p, 0) * convmul / convdiv ;
 			len = p-buf;
-			if ((len < left) && *p && !isspace(*p))
+			if ((len < left) && *p && !isspace(*p)) {
+				ret = -EINVAL;
 				break;
+			}
 			if (neg)
 				val = -val;
 			s += len;
@@ -2532,8 +2543,10 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 
 			if(neg)
 				continue;
-			if ((min && val < *min) || (max && val > *max))
-				continue;
+			if ((min && val < *min) || (max && val > *max)) {
+				ret = -EINVAL;
+				break;
+			}
 			*i = val;
 		} else {
 			p = buf;
@@ -2567,6 +2580,8 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 	}
 	if (write && first)
 		return -EINVAL;
+	if (write && ret)
+		return ret;
 	*lenp -= left;
 	*ppos += *lenp;
 	return 0;
