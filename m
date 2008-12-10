Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbYLJXqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbYLJXqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 18:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbYLJXpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 18:45:45 -0500
Received: from smtp-out.google.com ([216.239.45.13]:21365 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932AbYLJXpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 18:45:44 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject;
	b=ZE28f2xSKqL5koR5tqmKpJeHoT1JIP9642r2zQv1W1x3SYyMiJuJ8qxfE8ysNi4ST
	JqsUJU2zSasetOShoB8YA==
Message-Id: <20081210233654.563182000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Wed, 10 Dec 2008 15:36:54 -0800
From: menage@google.com
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [RFC][PATCH 0/3] CGroups: CGroups: Hierarchy locking/refcount changes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches present an alternative to some of the other cgroups
locking/refcount patches that have been proposed on LKML recently.

Several of these patches have been to address the race opened by
moving the calls to pre_destroy() callbacks outside of cgroup_mutex;
rather than continuing to patch up the holes caused by that change,
these patches introduce new locking/refcount rules to ultimately allow
the previous atomicity of cgroup_rmdir() to be restored.

These three patches give:

1/3 - introduce a per-subsystem hierarchy_mutex which a subsystem can
      use to prevent changes to its own cgroup tree

2/3 - use hierarchy_mutex in place of calling cgroup_lock() in the
      memory controller

3/3 - introduce a css_tryget() function similar to the one proposed by
      Kamezawa, but avoiding spurious refcount failures in the event
      of a race between a css_tryget() and an unsuccessful cgroup_rmdir()

Future patches will likely involve:

- using hierarchy mutex in place of cgroup_lock() in more subsystems
  where appropriate

- restoring the atomicity of cgroup_rmdir() with respect to cgroup_create()

Signed-off-by: Paul Menage <menage@google.com>

