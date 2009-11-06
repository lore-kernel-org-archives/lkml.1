Return-Path: <linux-kernel-owner+w=401wt.eu-S1760403AbZKFW27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760403AbZKFW27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932640AbZKFWXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:31 -0500
Received: from kroah.org ([198.145.64.141]:57056 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932607AbZKFWXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:24 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:48 2009
Message-Id: <20091106221548.693605803@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Howells <dhowells@redhat.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: [72/99] KEYS: get_instantiation_keyring() should inc the keyring refcount in all cases
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=keys-get_instantiation_keyring-should-inc-the-keyring-refcount-in-all-cases.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Howells <dhowells@redhat.com>

commit 21279cfa107af07ef985539ac0de2152b9cba5f5 upstream.

The destination keyring specified to request_key() and co. is made available to
the process that instantiates the key (the slave process started by
/sbin/request-key typically).  This is passed in the request_key_auth struct as
the dest_keyring member.

keyctl_instantiate_key and keyctl_negate_key() call get_instantiation_keyring()
to get the keyring to attach the newly constructed key to at the end of
instantiation.  This may be given a specific keyring into which a link will be
made later, or it may be asked to find the keyring passed to request_key().  In
the former case, it returns a keyring with the refcount incremented by
lookup_user_key(); in the latter case, it returns the keyring from the
request_key_auth struct - and does _not_ increment the refcount.

The latter case will eventually result in an oops when the keyring prematurely
runs out of references and gets destroyed.  The effect may take some time to
show up as the key is destroyed lazily.

To fix this, the keyring returned by get_instantiation_keyring() must always
have its refcount incremented, no matter where it comes from.

This can be tested by setting /etc/request-key.conf to:

#OP	TYPE	DESCRIPTION	CALLOUT INFO	PROGRAM ARG1 ARG2 ARG3 ...
#======	=======	===============	===============	===============================
create  *	test:*		*		|/bin/false %u %g %d %{user:_display}
negate	*	*		*		/bin/keyctl negate %k 10 @u

and then doing:

	keyctl add user _display aaaaaaaa @u
        while keyctl request2 user test:x test:x @u &&
        keyctl list @u;
        do
                keyctl request2 user test:x test:x @u;
                sleep 31;
                keyctl list @u;
        done

which will oops eventually.  Changing the negate line to have @u rather than
%S at the end is important as that forces the latter case by passing a special
keyring ID rather than an actual keyring ID.

Reported-by: Alexander Zangerl <az@bond.edu.au>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Alexander Zangerl <az@bond.edu.au>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/keys/keyctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -860,7 +860,7 @@ static long get_instantiation_keyring(ke
 	/* otherwise specify the destination keyring recorded in the
 	 * authorisation key (any KEY_SPEC_*_KEYRING) */
 	if (ringid >= KEY_SPEC_REQUESTOR_KEYRING) {
-		*_dest_keyring = rka->dest_keyring;
+		*_dest_keyring = key_get(rka->dest_keyring);
 		return 0;
 	}
 


