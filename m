Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbZFBAao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbZFBAao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 20:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbZFBAah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 20:30:37 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58775 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbZFBAah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 20:30:37 -0400
Message-Id: <200906020030.n520UU1D087893@www262.sakura.ne.jp>
Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v2)
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: serge@hallyn.com
Cc: serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Jun 2009 09:30:30 +0900
References: <alpine.LRH.2.00.0905151146320.5937@tundra.namei.org> <200905162107.HCE17153.HLSFMtOOFVFOJQ@I-love.SAKURA.ne.jp> <200905250037.n4P0bFwe057503@www262.sakura.ne.jp> <200905250039.n4P0dSIE058041@www262.sakura.ne.jp> <200905250041.n4P0fVCT058575@www262.sakura.ne.jp> <200906012227.FDE64040.MVQLOStOHFOFFJ@I-love.SAKURA.ne.jp> <20090602001137.GA20880@hallyn.com>
In-Reply-To: <20090602001137.GA20880@hallyn.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 01062009 #2072025, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Can't you just move the deleted item from the live list to some dead
> list, using the same ->list list_head?

I think I can't. If we do list_add(&p->entry.list, &dead_list) after
list_del_rcu(&p->entry.list) when p->entry.users != 0, p->entry.list.next will
point to an element on dead list. And reader will no longer be able to resume
travarsal on the live list.

I don't want the item be deleted from the live list as long as there are
readers (i.e. p->entry.users != 0).

If we use different ->list list_head, reader will be able to resume travarsal
on the live list. (But will use more memory than ->is_deleted.)

struct something {
	struct {
		struct list_head list_for_live_list;
		atomic_t users;
	} entry;
	struct list_head list_for_dead_list;
	int data;
} *p;

Regards.
