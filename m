Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZGNTBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZGNTBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 15:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbZGNTB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 15:01:29 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44745 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbZGNTB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 15:01:29 -0400
Subject: Re: [PATCH 1/3] Adds a read-only "procs" file similar to "tasks"
 that shows only unique tgids
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Ben Blum <bblum@google.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, lizf@cn.fujitsu.com,
       menage@google.com
In-Reply-To: <20090710230154.16778.58053.stgit@hastromil.mtv.corp.google.com>
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>
	 <20090710230154.16778.58053.stgit@hastromil.mtv.corp.google.com>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 11:34:30 -0700
Message-Id: <1247596470.13426.16088.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 16:01 -0700, Ben Blum wrote:
> +struct cgroup_pidlist {
> +       /* protects the other fields */
> +       struct rw_semaphore mutex;
> +       /* array of xids */
> +       pid_t *list;
> +       /* how many elements the above list has */
> +       int length;
> +       /* how many files are using the current array */
> +       int use_count;
> +};

I think a slightly nicer way of doing this would be to use a structure
like this:

#define NR_PIDS (PAGE_SIZE-sizeof(struct list_head))
struct pid_list {
	struct list_head list;
	pid_t pids[NR_PIDS];
};

That way, you can always kmalloc(sizeof(pid_list)), it fits nicely in
PAGE_SIZE, and you can chain them together.

Or, you could always just use one of the other flexible structures in
the kernel like a radix_tree.

-- Dave

