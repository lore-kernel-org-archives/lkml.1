Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbZALTf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbZALTf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbZALTfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:35:48 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:46905 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbZALTfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:35:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DtJ2hikcK9+CJg0BCPZhFAOGMCPh1I9nmWKKKkb1FdvzHuj+Li4lqPkU/J/+Lz0gkn
         B4+s3o4zyrDKiXHYPwCTkvfB9lMkANYAOZnEAzlKBW60VG1mlHnGMzxkBmyZOAnxulT8
         rsEAoetWp+fMWh7PtBF2XC7DPODHffE83Atng=
Message-ID: <524f69650901121135m2fb6f12eqc64ebe3c7be11a0d@mail.gmail.com>
Date: Mon, 12 Jan 2009 13:35:45 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
Subject: Re: linux-next: Tree for January 12 (cifs vs. staging)
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, sfrench@samba.org,
       "Greg KH" <gregkh@suse.de>
In-Reply-To: <1231787958.6383.18.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090112154539.4857f533.sfr@canb.auug.org.au>
	 <496B899E.7060605@oracle.com>
	 <524f69650901121058g73c8022eif1d1bcca5c0e01fa@mail.gmail.com>
	 <1231787958.6383.18.camel@norville.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

md5 support of course belongs in crypto/md5.c in a perfect world

The fs/cifs/md5.c code (and cifs/md4.c for that matter) is very
generic md5 code, nothing much cifs specific although it would be
worth looking at whether there are endian issues.

CIFS uses md5 in two places, calculating an hmac in fs/cifs/md5.c and
then in calculating packet signatures on SMB/CIFS packets.  CIFS usage
of md5 is really simple (see below), basically we run MD5 on an
SMB/CIFS packet passing in the length (and the key) to calculate a 20
byte signature (which is sent to the server on requests, and we
calculate the expected signature to verify that responses from the
server have not been tampered with).   When we last checked on this
with the crypto guys, it would take a lot more code to do this using
the common crypto routines since they were setup to handle more
complex use cases.

static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
                                    const struct mac_key *key, char *signature)
{
        struct  MD5Context context;
...
        MD5Init(&context);
        MD5Update(&context, (char *)&key->data, key->len);
        MD5Update(&context, cifs_pdu->Protocol /* beginning of packet
*/, cifs_pdu->smb_buf_length);
        MD5Final(signature, &context);
        return 0;
}


On Mon, Jan 12, 2009 at 1:19 PM, Dave Kleikamp
<shaggy@linux.vnet.ibm.com> wrote:
> On Mon, 2009-01-12 at 12:58 -0600, Steve French wrote:
>> There is not just the cifs md5 one (which has been around a long
>> time), but an md5_init (static) in crypto and the new one in rt.  The
>> addition of the new one (rt md5_init) causes the build problem.   It
>> would be nice if we could use the same md5 routines though ... last
>> time we checked the crypto one was not well suited for calculating
>> signatures as a network fs would do though.
>
> Is that due to the byte-swapping?  Can the cifs and rt* drivers use the
> same code.  rt28[67]0/common/md5.c are identical files.  In fact those
> "common" directories should probably be combined into a single truly
> common directory.
>
>> On Mon, Jan 12, 2009 at 12:19 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> > Stephen Rothwell wrote:
>> >> Hi all,
>> >>
>> >> Some people took me at my word and so we have the 2.6.30 code starting to
>> >> trickle in already.
>> >
>> >
>> >
>> > When CIFS is built-in (=y) and staging/rt28[67]0 =y, there are multiple
>> > definitions of:
>> >
>> > build-r8250.out:(.text+0x1d8ad0): multiple definition of `MD5Init'
>> > build-r8250.out:(.text+0x1dbb30): multiple definition of `MD5Update'
>> > build-r8250.out:(.text+0x1db9b0): multiple definition of `MD5Final'
>> >
>> > all of which need to have more unique identifiers for their global
>> > symbols (e.g., rt28_md5_init, cifs_md5_init, foo, blah, bar).
>> >
>> >
>> > --
>> > ~Randy
>> >
>>
>>
>>
> --
> David Kleikamp
> IBM Linux Technology Center
>
>



-- 
Thanks,

Steve
