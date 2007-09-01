Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbXIAEuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbXIAEuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 00:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbXIAEu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 00:50:27 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:29131 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbXIAEu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 00:50:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=cpOSKaz3mAJE65Ak7V+sATkaYYvarK6NNUrLTHexJkL8rz4cO2BV2ZiQRP94KSjNpzEev49PSzVSLYR5PpVt7wPZGkY4hksrZcPf7uPntPzkg7xOz7oYXr/20fKBA97y/ezm2zQiTK403TfAeItJyWA1cnDCj0YT18jvLNNT0PY=
Date: Sat, 1 Sep 2007 08:50:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: socket locking obscure code
Message-ID: <20070901045020.GA7221@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi LKML,
 
looking thru lock_sock_nested (while trying to catch
BUG in CIFS as reported on bugzilla #8377) I found
that lock_sock_nested consist of:

void fastcall lock_sock_nested(struct sock *sk, int subclass)
{
	might_sleep();
--->	spin_lock_bh(&sk->sk_lock.slock);
	if (sk->sk_lock.owner)
		__lock_sock(sk);
	sk->sk_lock.owner = (void *)1;
--->	spin_unlock(&sk->sk_lock.slock);
	/*
	 * The sk_lock has mutex_lock() semantics here:
	 */
	mutex_acquire(&sk->sk_lock.dep_map, subclass, 0, _RET_IP_);
	local_bh_enable();
}
 
so why spin_unlock are there instead of spin_unlock_bh?
To recope with __lock_sock? Am I right?
 
 		Cyrill
 
