Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbZI2RJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbZI2RJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZI2RJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:09:06 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36225 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbZI2RJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:09:04 -0400
Message-ID: <4AC23F27.20804@linux.vnet.ibm.com>
Date: Tue, 29 Sep 2009 12:08:55 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ecryptfs-devel@lists.launchpad.net,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH -mmotm] ecryptfs: depends on CRYPTO
References: <200909252158.n8PLwFhG024011@imap1.linux-foundation.org> <20090928133420.f53a015f.randy.dunlap@oracle.com> <4AC15058.8020709@linux.vnet.ibm.com> <20090928172024.9f944f16.randy.dunlap@oracle.com>
In-Reply-To: <20090928172024.9f944f16.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.97a
OpenPGP: id=5D35E502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2009 07:20 PM, Randy Dunlap wrote:
> On Mon, 28 Sep 2009 19:10:00 -0500 Tyler Hicks wrote:
> 
>> On 09/28/2009 03:34 PM, Randy Dunlap wrote:
>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>
>>> ecryptfs uses crypto APIs so it should depend on CRYPTO.
>>> Otherwise many build errors occur. [63 lines not pasted]
>>>
>>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>>> ---
>>>  fs/ecryptfs/Kconfig |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> --- mmotm-2009-0925-1435.orig/fs/ecryptfs/Kconfig
>>> +++ mmotm-2009-0925-1435/fs/ecryptfs/Kconfig
>>> @@ -1,6 +1,6 @@
>>>  config ECRYPT_FS
>>>  	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
>>> -	depends on EXPERIMENTAL && KEYS && NET
>>> +	depends on EXPERIMENTAL && KEYS && NET && CRYPTO
>>>  	select CRYPTO_ECB
>>>  	select CRYPTO_CBC
>>>  	help
>>
>> Hi Randy - Thanks for the patch!  Unfortunately, I think it defeats what
>> Dave Hansen was wanting to do with commit
>> 382684984e93039a3bbd83b04d341b0ceb831519.
>>
>> When I pulled that patch in, I was under the assumption that the select
>> would also select all necessary dependencies.  According to
>> Documentation/kbuild/kconfig-language.txt, that's not the case:
>>
>> 	select should be used with care. select will force
>> 	a symbol to a value without visiting the dependencies.
>>         By abusing select you are able to select a symbol FOO even
>>         if FOO depends on BAR that is not set.
>>
>> Maybe we should do it how other folks are tackling this problem and
>> select CRYPTO, along with CRYPTO_ECB and CRYPTO_CBC.  While we're at it,
>> we should probably throw in CRYPTO_AES (aes-128 is the default cipher,
>> but the cipher is configurable at mount so it might be too obtrusive for
>> us to select it) and CRYPTO_MD5 (our default hash alg, not currently
>> configurable).  Also, we don't depend on NET anymore because our netlink
>> interface is no longer around.  It may not hurt to select KEYS, rather
>> than depend on it.  Does all of this sound sane to you?
> 
> It selects too much stuff.  "select" should not be used to enable
> a full subsystem (that's my general rule, not in kconfig-language.txt).
> What kconfig-language.txt says that applies here is just after your
> quoted text:
> 
> 	In general use select only for non-visible symbols
> 	(no prompts anywhere) and for symbols with no dependencies.
> 	That will limit the usefulness but on the other hand avoid
> 	the illegal configurations all over.
> 
> CRYPTO does not fit that.
> 
> One of the big problems with selecting kconfig symbols (like subsystem
> ones) is that it makes it difficult to disable that symbol, which some
> of us often want to do.
> 
> 
> ---
> ~Randy

eCryptfs wouldn't be the first to select CRYPTO:

$ grep -r "select CRYPTO$" --include=Kconfig . | wc -l
26

But after trying to deselect CRYPTO with one of my custom configs, I
realized that you are right. :)  Depending on CRYPTO and then selecting
the proper CRYPTO_* symbols is the way to go.

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git#next

Thanks again!

Tyler
