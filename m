Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbZGIKkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbZGIKkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 06:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbZGIKkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 06:40:10 -0400
Received: from mail.open.by ([193.232.92.17]:50739 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401AbZGIKkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 06:40:09 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 8979 [Jul 09 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Thu, 9 Jul 2009 13:42:02 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: kmemeleak BUG: lock held when returning to user space!
Message-ID: <20090709104202.GA3434@localdomain.by>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

kernel: [  149.507103] ================================================
kernel: [  149.507113] [ BUG: lock held when returning to user space! ]
kernel: [  149.507119] ------------------------------------------------
kernel: [  149.507127] cat/3279 is leaving the kernel with locks still held!
kernel: [  149.507135] 1 lock held by cat/3279:
kernel: [  149.507141]  #0:  (scan_mutex){+.+.+.}, at: [<c110707c>] kmemleak_open+0x4c/0x80

problem is here:
static int kmemleak_open(struct inode *inode, struct file *file)
{
	int ret = 0;

	if (!atomic_read(&kmemleak_enabled))
		return -EBUSY;

	ret = mutex_lock_interruptible(&scan_mutex);
	if (ret < 0)
		goto out;
	if (file->f_mode & FMODE_READ) {
		ret = seq_open(file, &kmemleak_seq_ops);
		if (ret < 0)
			goto scan_unlock;
	}
>>-	return ret;

scan_unlock:
	mutex_unlock(&scan_mutex);
out:
	return ret;
}

we should not return before mutex_unlock(&scan_mutex);

	Sergey

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkpVyXoACgkQfKHnntdSXjRE8wP/dQjwYNJnTVeEebnGMlsUZpS9
klr+L0s+3eKBBLjGEG17SE9jcVWwvRUBAYwumMXTHGLCrTwaYX18j4QR6EDNT3Gi
dWl2maYbYRsUl2S9gFMbqjy8DHV0CR6Fv/jlMHCkWt/NkrGXzgd2ltOBGVhj6bnU
GGIMykJwJQmHIda6By0=
=9+4L
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
