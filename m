Return-Path: <linux-kernel-owner+w=401wt.eu-S1759188AbZCMQLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188AbZCMQLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758531AbZCMQK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:10:57 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40610 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756933AbZCMQK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:10:56 -0400
Message-ID: <49BA857D.5060805@linux.vnet.ibm.com>
Date: Fri, 13 Mar 2009 11:10:37 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dustin Kirkland <kirkland@canonical.com>
Subject: Re: [PATCH] eCryptfs: Don't encrypt file key with filename key
References: <20090313062410.GA32384@boomer> <20090313133916.GA32304@us.ibm.com>
In-Reply-To: <20090313133916.GA32304@us.ibm.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=5D35E502
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEFBAD0ADF98ECEC98F2089EB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEFBAD0ADF98ECEC98F2089EB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Serge E. Hallyn wrote:
> Quoting Tyler Hicks (tyhicks@linux.vnet.ibm.com):
>> eCryptfs has file encryption keys (FEK), file encryption key encryptio=
n
>> keys (FEKEK), and filename encryption keys (FNEK).  The per-file FEK i=
s
>> encrypted with one or more FEKEKs and stored in the header of the
>> encrypted file.  I noticed that the FEK is also being encrypted by the=

>> FNEK.  This is a problem if a user wants to use a different FNEK than
>> their FEKEK, as their file contents will still be accessible with the
>> FNEK.
>>
>> This is a minimalistic patch which prevents the FNEKs signatures from
>> being copied to the inode signatures list.  Ultimately, it keeps the F=
EK
>> from being encrypted with a FNEK.
>=20
> Right, so the file name encryption key is the same for all the files,
> whereas you can have multiple file encryption key encryption keys.
> So this bug means that the ability to have multiple FEKEKs becomes
> completely worthless.
>=20
> This makes me wonder if it's not worth doing a complete code-vs-design
> comparison to make sure there are no other such gems hidden away.

After becoming the primary contact for the eCryptfs kernel code, I've
slowly been doing this.  That's sort of how I came across this problem.
 Keep in mind that filename encryption is pretty new and 2.6.29 is the
first release it will be in.

>=20
> Tyler, do you have a user-space (hopefully easier-to-read) parser for
> encrypted ecryptfs files?  (ISTR they were closely following a gpg
> format)

This is very much needed!  Especially with filename encryption.
ecryptfs-stat exists in the ecryptfs-utils package, but it doesn't have
too much functionality yet.  I'll open a couple bugs against
ecryptfs-stat and subscribe you so that you can stay updated.

>=20
>> Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
>> ---
>>  fs/ecryptfs/crypto.c          |    2 ++
>>  fs/ecryptfs/ecryptfs_kernel.h |    3 ++-
>>  fs/ecryptfs/keystore.c        |    3 ++-
>>  fs/ecryptfs/main.c            |    5 +++--
>>  4 files changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
>> index f6caeb1..bdca1f4 100644
>> --- a/fs/ecryptfs/crypto.c
>> +++ b/fs/ecryptfs/crypto.c
>> @@ -946,6 +946,8 @@ static int ecryptfs_copy_mount_wide_sigs_to_inode_=
sigs(
>>  	list_for_each_entry(global_auth_tok,
>>  			    &mount_crypt_stat->global_auth_tok_list,
>>  			    mount_crypt_stat_list) {
>> +		if (global_auth_tok->flags & ECRYPTFS_AUTH_TOK_FNEK)
>> +			continue;
>>  		rc =3D ecryptfs_add_keysig(crypt_stat, global_auth_tok->sig);
>>  		if (rc) {
>>  			printk(KERN_ERR "Error adding keysig; rc =3D [%d]\n", rc);
>> diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kern=
el.h
>> index c11fc95..eb2267e 100644
>> --- a/fs/ecryptfs/ecryptfs_kernel.h
>> +++ b/fs/ecryptfs/ecryptfs_kernel.h
>> @@ -328,6 +328,7 @@ struct ecryptfs_dentry_info {
>>   */
>>  struct ecryptfs_global_auth_tok {
>>  #define ECRYPTFS_AUTH_TOK_INVALID 0x00000001
>> +#define ECRYPTFS_AUTH_TOK_FNEK    0x00000002
>>  	u32 flags;
>>  	struct list_head mount_crypt_stat_list;
>>  	struct key *global_auth_tok_key;
>> @@ -696,7 +697,7 @@ ecryptfs_write_header_metadata(char *virt,
>>  int ecryptfs_add_keysig(struct ecryptfs_crypt_stat *crypt_stat, char =
*sig);
>>  int
>>  ecryptfs_add_global_auth_tok(struct ecryptfs_mount_crypt_stat *mount_=
crypt_stat,
>> -			   char *sig);
>> +			   char *sig, u32 global_auth_tok_flags);
>>  int ecryptfs_get_global_auth_tok_for_sig(
>>  	struct ecryptfs_global_auth_tok **global_auth_tok,
>>  	struct ecryptfs_mount_crypt_stat *mount_crypt_stat, char *sig);
>> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
>> index ff53942..e4a6223 100644
>> --- a/fs/ecryptfs/keystore.c
>> +++ b/fs/ecryptfs/keystore.c
>> @@ -2375,7 +2375,7 @@ struct kmem_cache *ecryptfs_global_auth_tok_cach=
e;
>> =20
>>  int
>>  ecryptfs_add_global_auth_tok(struct ecryptfs_mount_crypt_stat *mount_=
crypt_stat,
>> -			     char *sig)
>> +			     char *sig, u32 global_auth_tok_flags)
>>  {
>>  	struct ecryptfs_global_auth_tok *new_auth_tok;
>>  	int rc =3D 0;
>> @@ -2389,6 +2389,7 @@ ecryptfs_add_global_auth_tok(struct ecryptfs_mou=
nt_crypt_stat *mount_crypt_stat,
>>  		goto out;
>>  	}
>>  	memcpy(new_auth_tok->sig, sig, ECRYPTFS_SIG_SIZE_HEX);
>> +	new_auth_tok->flags =3D global_auth_tok_flags;
>>  	new_auth_tok->sig[ECRYPTFS_SIG_SIZE_HEX] =3D '\0';
>>  	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);
>>  	list_add(&new_auth_tok->mount_crypt_stat_list,
>> diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
>> index 789cf2e..aed56c2 100644
>> --- a/fs/ecryptfs/main.c
>> +++ b/fs/ecryptfs/main.c
>> @@ -319,7 +319,7 @@ static int ecryptfs_parse_options(struct super_blo=
ck *sb, char *options)
>>  		case ecryptfs_opt_ecryptfs_sig:
>>  			sig_src =3D args[0].from;
>>  			rc =3D ecryptfs_add_global_auth_tok(mount_crypt_stat,
>> -							  sig_src);
>> +							  sig_src, 0);
>>  			if (rc) {
>>  				printk(KERN_ERR "Error attempting to register "
>>  				       "global sig; rc =3D [%d]\n", rc);
>> @@ -370,7 +370,8 @@ static int ecryptfs_parse_options(struct super_blo=
ck *sb, char *options)
>>  				ECRYPTFS_SIG_SIZE_HEX] =3D '\0';
>>  			rc =3D ecryptfs_add_global_auth_tok(
>>  				mount_crypt_stat,
>> -				mount_crypt_stat->global_default_fnek_sig);
>> +				mount_crypt_stat->global_default_fnek_sig,
>> +				ECRYPTFS_AUTH_TOK_FNEK);
>>  			if (rc) {
>>  				printk(KERN_ERR "Error attempting to register "
>>  				       "global fnek sig [%s]; rc =3D [%d]\n",
>> --=20
>> 1.5.3.7



--------------enigEFBAD0ADF98ECEC98F2089EB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkm6hYkACgkQqDCb9l015QLW5gCdH+aG/9enchlpr813eDI7Ixc4
hNkAn3STR1UdaCLopqv1Y8Ue0oWD0+9s
=FMO2
-----END PGP SIGNATURE-----

--------------enigEFBAD0ADF98ECEC98F2089EB--
