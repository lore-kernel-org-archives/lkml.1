Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYINPp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYINPp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbYINPpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:45:19 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:45518 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYINPpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:45:18 -0400
Message-ID: <48CD3069.7080200@cs.columbia.edu>
Date: Sun, 14 Sep 2008 11:40:25 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Bastian Blank <bastian@waldi.eu.org>, Oren Laadan <orenl@cs.columbia.edu>,
       dave@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC v5][PATCH 8/8] Dump open file descriptors
References: <1221347167-9956-1-git-send-email-orenl@cs.columbia.edu> <1221347167-9956-9-git-send-email-orenl@cs.columbia.edu> <20080914095106.GA6300@wavehammer.waldi.eu.org>
In-Reply-To: <20080914095106.GA6300@wavehammer.waldi.eu.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Bastian Blank wrote:
> On Sat, Sep 13, 2008 at 07:06:06PM -0400, Oren Laadan wrote:
>> +int cr_scan_fds(struct files_struct *files, int **fdtable)
>> +{
>> +	struct fdtable *fdt;
>> +	int *fds;
>> +	int i, n, tot;
>> +
>> +	n = 0;
>> +	tot = CR_DEFAULT_FDTABLE;
> 
> Why not?
> | int i;
> | int n = 0;
> | int tot = CR_DEFAULT_FDTABLE;
> 
> IHMO easier readable.

Ok.

> 
>> +	spin_lock(&files->file_lock);
>> +	fdt = files_fdtable(files);
>> +	for (i = 0; i < fdt->max_fds; i++) {
> 
> The process is suspended at this state?

Yes, the assumption is that the process is frozen (or that we checkpoint
ourselves).

With this assumption, it is possible to (a) leave out RCU locking, and also
(b) continue after the krealloc() from where we left off. Also, it means that
(c) the contents of our 'fds' array remain valid by the time the caller makes
use of it.

This certainly deserves a comment in the code, will add.

If the assumption doesn't hold, then I'll have to add the RCU locking. Cases
(b) and (c) are already safe because the caller(s) use fcheck_files() to
access the file-descriptors collected in the array.

While in my mind a task should never be unfrozen while being checkpointed, in
reality future code may allow it e.g. if a OOM kicks in a kills it. So I tend
to add the RCU lock for safety. It can always be optimized out later.

> 
>> +		if (n == tot) {
>> +			/*
>> +			 * fcheck_files() is safe with drop/re-acquire
>> +			 * of the lock, because it tests:  fd < max_fds
>> +			 */
>> +			spin_unlock(&files->file_lock);
>> +			tot *= 2;
>> +			if (tot < 0) {		/* overflow ? */
> 
> _NO_. tot is signed, this does not have documented overflow behaviour.
> You need to restrict this to a sane number.

Ok. (btw, krealloc() will fail much earlier anyway).

> 
>> +				kfree(fds);
>> +				return -EMFILE;
>> +			}
>> +			fds = krealloc(fds, tot * sizeof(*fds), GFP_KERNEL);
>> +			if (!fds)
> 
> krealloc does not free the memory on error, so this is a leak.

Ok.

Thanks,

Oren.
