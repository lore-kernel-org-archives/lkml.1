Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbXAXRGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbXAXRGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 12:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbXAXRGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 12:06:36 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50213 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbXAXRGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 12:06:35 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, containers@lists.osdl.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 4/8] user ns: hook permission
References: <20061219225902.GA25904@sergelap.austin.ibm.com>
	<20061219230051.GE25904@sergelap.austin.ibm.com>
Date: Wed, 24 Jan 2007 10:06:03 -0700
In-Reply-To: <20061219230051.GE25904@sergelap.austin.ibm.com> (Serge
	E. Hallyn's message of "Tue, 19 Dec 2006 17:00:51 -0600")
Message-ID: <m14pqg2w3o.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> From: Serge E. Hallyn <serue@us.ibm.com>
> Subject: [PATCH 4/8] user ns: hook permission
>
> Hook permission to check vfsmnt->user_ns against current.

This looks wrong on several levels.
- This should ultimately be inside generic_permission instead of
  permission as there are some distributed filesystems that know how to cope with
  multiple mount namespaces simultaneous.

- As implemented the test is not what I would expect.  I would
  expect comparisons of uid X == uid Y and gid X == gid Y to
  be replaced by comparing the tuples of uid namesspace and uid.
  Which would allow access to world readable/writeable files,
  and it would allow users with CAP_DAC_OVERRIDE to be able to access
  everything.

All we are really saying as I understand a user namespace is that 
instead of uid's uniquely identifying a user the pair the pair uidns,
uid is uniquely identifies a user.

Because you didn't pick what I would consider the obvious choice
you now need an extra mount flag to disable the uid namespace all
together, so you can transition through the intermediate uid namespace
state.  That really feels wrong.

All mounts should have an associated uid namespace and the only
way you should be able to ignore that is to access filesystems
that can cope with multiple uid namespaces simultaneously.

Eric
